def extract_data(items, data_hash)
    normalized_data_hash = {}
    items.each do |item|
        text = item.text
        data_hash.each_key do |key|
            match = text.match(/\b#{key}\b\s+(.+)/)
            if match
                value = match[1].gsub('>', '').strip
                normalized_key = key.downcase.split.join("_")
                normalized_data_hash[normalized_key] = value
                data_hash.delete(key)
            end
        end
    end
    data_hash.merge!(normalized_data_hash)
end
