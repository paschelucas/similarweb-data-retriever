def extract_data(items, data_hash)
    items.each do |item|
        text = item.text
        puts 'texto', text
        data_hash.each_key do |key|
            puts 'key', key
            match = text.match(/\b#{key}\b\s+(.+)/)
            if match
                value = match[1].gsub('>', '').strip
                data_hash[key] = value
                break  # Saia do loop após encontrar uma correspondência
            end
        end
    end
end
