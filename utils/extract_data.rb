def extract_data(items, data_hash)
    items.each do |item|
        text = item.text
        data_hash.each_key do |key|
            match = text.match(/\b#{key}\b\s+(.+)/)
            if match
                value = match[1].gsub('>', '').strip
                data_hash[key] = value
            end
        end
    end
end