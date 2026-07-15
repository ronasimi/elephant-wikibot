return {
    Name = "wikibot",
    NamePretty = "Wikibot",
    Icon = "system-search",
    Terminal = false,
    Cache = true,
    Action = "xdg-open '%VALUE%'",
    GetEntries = function(term)
        if term == nil or term == "" then return {} end

        local safe_term = term:gsub(" ", "%%20")
        
        -- Fetch top 3 results from Wikipedia's Query API
        local wiki_cmd = string.format(
            [[curl -s 'https://en.wikipedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=%s&gsrlimit=3&prop=extracts|info&exchars=1500&explaintext=1&inprop=url' | jq -r '.query.pages | to_entries[] | .value | "\(.title)===||===\(.extract // "No content." | gsub("\n"; " "))===||===\(.fullurl)"']], 
            safe_term
        )
        
        local handle = io.popen(wiki_cmd)
        local result = handle:read("*a")
        handle:close()

        if not result or result == "" then
            return {{ Text = "No results found.", Value = "" }}
        end

        local entries = {}

        for line in result:gmatch("[^\r\n]+") do
            local title, extract, link = line:match("(.*)===||===(.*)===||===(.*)")
            
            if title and extract and link then
                local safe_extract = extract:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("'", "")

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

                summary = summary:gsub("^%s*(.-)%s*$", "%1") 

                table.insert(entries, {
                    Text = string.format("<span weight='semibold' size='16pt'>%s</span>", title),
                    Subtext = summary .. "\n\n" .. link,
                    Value = link,
                    Icon = "web-browser"
                })
            end
        end

        return entries
    end
}
