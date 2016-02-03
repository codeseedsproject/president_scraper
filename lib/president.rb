require "nokogiri"
require "open-uri"
require "csv"

class President
  attr_reader :wiki
  attr_accessor :president_array

  def initialize 
    @wiki = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States"))
    @president_array = []
  end 
    
  def parsed_rows
    wiki.xpath('//table[@class="wikitable"]/tr')
  end

  def generate_row_data
    parsed_rows.each do |node|
      next if CssParser.text('th', node).empty?
      params = { number:     CssParser.text('th', node),
                 name:       CssParser.text('td[3] a', node), 
                 full_names: CssParser.text('td[4] big a', node), 
                 bday:       CssParser.text('td[4] small', node), 
                 state:      CssParser.text('td[5]', node), 
                 dates:      CssParser.text('td[6]', node), 
                 party:      CssParser.text('td[7]', node), 
                 previous:   CssParser.text( 'td[9]', node), 
                 vp:         CssParser.text('td[11]', node) 
               }
      president_array.push PresidentRow.new(params)
    end
  end

  def csv
    CSV.open('presidents.csv', 'w') do |row| 
      row << ["Number", "Full Name", "DOB", "State", "Term of Office", "Party", "Previous Office", "Vice President"]
      president_array.each do |president|
        row << [president.number, president.full_names, president.bday, president.state, president.dates, president.party, president.previous, president.vp]
      end
    end
  end
end

class PresidentRow
  attr_reader :number, :name, :full_names, :bday, :state, :dates, :party, :previous, :vp
  
  def initialize(args = {})
    @number     = args[:number]
    @name       = args[:name]
    @full_names = args[:full_names]
    @bday       = args[:bday]
    @state      = args[:state]
    @dates      = args[:dates]
    @party      = args[:party]
    @previous   = args[:previous]
    @vp         = args[:vp]
  end
end

class CssParser
  def self.text(css_selector, node)
    search_for = node.search(css_selector)
    search_for.text
  end
end

p = President.new
p.generate_row_data
p.csv
