Gem::Specification.new do |s|
    s.name        = 'large_csv_reader'
    s.version     = '1.0.1'
    s.summary     = "Large CSV builder and proccesor"
    s.description = "Large CSV builder and proccesor, it can help with creation of large csv files, reading those files and make operation over the csv data"
    s.authors     = ["Arturo Castro"]
    s.email       = 'agcastro1994@gmail.com'
    s.files       = ["lib/large_csv_reader.rb", "lib/large_csv_reader/book_in_stock.rb", "large_csv_reader.gemspec", "README.md"]    
    s.license       = ''
    s.add_dependency 'csv', '~> 1.0'
    s.add_dependency 'date', '~> 1.0'
  end