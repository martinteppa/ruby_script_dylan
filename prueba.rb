require 'csv'

class AlbumFormatter

    #def order_array_by_year_and_name(hash_array, new_hash)
    #    my_index = nil
    #    hash_array.each_with_index do |hash, index|
    #        
    #        hash_key = hash[:year]
    #        if hash_key > new_hash[:year]
    #            my_index = index
    #            break
    #        elsif hash_key == new_hash[:year]
    #            result = new_hash[:title] <=> hash[:title]
    #            if result == -1 or result == 0 
    #                my_index = index
    #                break
    #            elsif hash[index+1] != nil
    #                result = new_hash[:title] <=> hash_array[index+1][:title]
    #               if result != -1 and result != 0 
    #                    my_index = index
    #                    break
    #                end
    #            end
    #        end
    #    end
    #
    #    if my_index != nil
    #        hash_array.insert(my_index, new_hash) 
    #    else
    #        hash_array.append(new_hash)
    #    end
    #    hash_array
    #end

    def order_array_by_year_and_name(hash_array)
      #fixed with chatGPT
      hash_array.sort_by! { |h| [h[:year], h[:title]] }
    end
  
    def execute
      csv_file = 'discography.txt'
      hash_response = Hash.new

      CSV.foreach(csv_file) do |row|
        begin
          year, *title = row.first.split
          title = title.join(' ')
          decade_key = "#{year[-2]}0's"
          if hash_response.has_key?decade_key
            hash_response[decade_key] = hash_response[decade_key].append({ year: year.to_i, title: title })
          else
            hash_response[decade_key] = Array.new.append({ year: year.to_i, title: title })
          end
        rescue StandardError => e
          puts "Error processing row: #{row}: #{e.message}"
        end
      end
      hash_response.each do |key, value|
        hash_response[key] = order_array_by_year_and_name(value)
      end
      p hash_response
    end
end


if __FILE__ == "prueba.rb"
    AlbumFormatter.new.execute
end


