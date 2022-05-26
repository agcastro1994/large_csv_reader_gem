require 'csv'
require 'date'
require 'large_csv_reader/book_in_stock'

class LargeCsvReader
    attr_accessor :books_in_stock
    def initialize
        @books_in_stock = []
    end

    def massive_csv_builder(filename,column_names,rowMultiplicator="1")
        generate_csv(filename,column_names)
        millions = rowMultiplicator.to_i
        millions.times do 
            append_to_csv(filename)
        end
    end

    def generate_csv(filename,column_names)       
        CSV.open(filename, "ab") do |csv|
            csv << column_names           
        end
    end

    def append_book_to_csv(filename,rows=1000000)
        CSV.open(filename, "ab") do |csv|          
            self.book_generator.lazy.select {|book| csv << [Date.new(2001,2,3), book.isbn, book.price] }.first(rows)        
        end
    end

    def append_to_csv(filename,rows=1000000,rowStructure)
        CSV.open(filename, "ab") do |csv|          
            self.row_generator(rowStructure).lazy.select {|row| csv << row }.first(rows)        
        end
    end

    def massive_read_in_csv_data(csv_file_name)
        CSV.foreach(csv_file_name, headers: true).each_slice(1).each {|row| @books_in_stock << BookInStock.new(row[0][1], row[0][2])}
    end

    def massive_total_value_in_stock(csv_file_name)
        CSV.foreach(csv_file_name, headers: true).each_slice(1).each.inject(0) {|sum, row| sum + row[0][2].to_f }
    end

    def massive_number_of_each_isbn(csv_file_name)
        counter_hash = {}
        CSV.foreach(csv_file_name, headers: true).each_slice(1).each {|row| number_of_each_isbn(counter_hash, row) }
        return counter_hash
    end

    def number_of_each_isbn(counter_hash, bookInfo)        
        isbn = bookInfo[0][1]
        if counter_hash.has_key?(isbn)
            counter_hash[isbn] = counter_hash[isbn]+1
        else
            counter_hash[isbn] = 1
        end        
        counter_hash
    end

    def book_generator
        Enumerator.new do |caller|  
            testBook = BookInStock.new("978-1-9343561-0-4", 20.05)                    
            loop do
                caller.yield testBook                
            end
        end
    end

    def row_generator(structure)
        Enumerator.new do |caller|  
            row = structure                    
            loop do
                caller.yield row                
            end
        end
    end

    # def add_new_book(book, filename)
    #     CSV.open(filename, "ab") do |csv|           
    #         csv << [Date.new(2001,2,3), book.isbn, book.price]
    #     end
    # end

    # def total_value_in_stock
    #     sum = 0.0
    #     @books_in_stock.each do |book|
    #         sum += book.price
    #     end
    #     sum
    # end

        # def read_in_csv_data(csv_file_name)
    #     CSV.foreach(csv_file_name, headers: true) do |row|
    #         @books_in_stock << BookInStock.new(
    #             row["ISBN"],
    #             row["Price"]
    #         )
    #     end
    # end

    # def generate_csv(filename,column_names, rows)
    #     records = self.book_generator.first(rows)
        
    #     CSV.open(filename, "ab") do |csv|
    #         csv << column_names
    #         10.times do 
    #             records.each do |book|
    #                 csv << [Date.new(2001,2,3), book.isbn, book.price]
    #             end
    #         end
    #     end
    # end

    # def number_of_each_isbn
        
    #     counter_hash = {}

    #     @books_in_stock.each do |book|
    #         isbn = book.isbn
    #         if counter_hash.has_key?(isbn)
    #             counter_hash[isbn] = counter_hash[isbn]+1
    #         else
    #             counter_hash[isbn] = 1
    #         end
    #     end
    #     counter_hash
    # end
end