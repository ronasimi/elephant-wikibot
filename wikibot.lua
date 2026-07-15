Name = "wikibot"
NamePretty = "Wikibot"
Icon = "system-search"
Terminal = false
Cache = true
Async = true
Action = "xdg-open '%VALUE%'"

function GetEntries(term)
    -- Wait for a '?' at the end of the query to prevent spamming the LLM
    if term == nil or not term:match("%?$") then
        return {{
            Text = "Ready to search: " .. (term or ""),
            Subtext = "Finish your query with a '?' to generate AI summaries.",
            Value = "",
            Icon = "system-search"
        }}
    end
    
    -- Remove the trailing '?' so it doesn't mess up the Wikipedia search
    local clean_term = term:sub(1, -2)
    local safe_term = string.gsub(clean_term, " ", "%%20")
    
    -- Fetch top result (Reduced to 1 to drastically speed up LLM generation)
    local wiki_cmd = string.format(
        [[curl -s 'https://en.wikipedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=%s&gsrlimit=1&prop=extracts|info&exchars=1500&explaintext=1&inprop=url' | jq -r '.query.pages | to_entries[] | .value | "\(.title)===||===\(.extract // "No content." | gsub("\n"; " "))===||===\(.fullurl)"']],
         safe_term
    )
    
    local handle = io.popen(wiki_cmd)
    local result = handle:read("*a")
    handle:close()

    if not result or result == "" then
        return {{ Text = "No results found for: " .. clean_term, Value = "" }}
    end

    local entries = {}
    for line in result:gmatch("[^\r\n]+") do
        local title, extract, link = line:match("(.*)===||===(.*)===||===(.*)")
        
        if title and extract and link then
            local safe_extract = string.gsub(extract, "\\", "\\\\")
            safe_extract = string.gsub(safe_extract, '"', '\\"')
            safe_extract = string.gsub(safe_extract, "'", "")
            safe_extract = string.gsub(safe_extract, "\n", " ")
            
            local prompt = string.format(
                [[<|im_start|>system\nYou are a helpful summarization assistant.<|im_end|>\n<|im_start|>user\nSummarize the following text into 2 to 3 short paragraphs highlighting the key points:\n\n%s<|im_end|>\n<|im_start|>assistant\n]],
                 safe_extract
            )
            
            local llama_cmd = string.format(
                [[curl -s -d '{"prompt": "%s", "n_predict": 350, "stream": false}' http://localhost:8080/completion | jq -r .content]],
                 prompt
            )
            
            local o_handle = io.popen(llama_cmd)
            local summary = o_handle:read("*a")
            o_handle:close()
            summary = string.gsub(summary, "^%s*(.-)%s*$", "%1")

            local safe_title = string.gsub(title, "&", "&amp;")
            safe_title = string.gsub(safe_title, "<", "&lt;")
            safe_title = string.gsub(safe_title, ">", "&gt;")

            table.insert(entries, {
                Text = string.format("<span weight='semibold' size='16pt'>%s</span>", safe_title),
                Subtext = summary .. "\n\n" .. link,
                Value = link,
                Icon = "web-browser"
            })
        end
    end
    return entries
end