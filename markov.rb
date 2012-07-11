require 'twitter'

CORPUS = Hash.new{Hash.new(0)}

def parseStatus txt
    txt.split /\s+/
end

def addToCorpus words
    last = ''
    for word in words
        addEdge last, word
        last = word
    end
    addEdge last, nil
end

def addEdge prev, nxt
    CORPUS[prev] = CORPUS[prev] or {}

    CORPUS[prev][nxt] += 1
end


def generate
    word = ""
    str = ""
    for i in 1..200
        ptr = getNext word
        return str if ptr.nil?
        str += ptr + " "
        word = ptr
    end   
    str
end

def getNext word
    edges = CORPUS[word]
    weighted = edges.map do |k,v|
        Array.new(v, k)
    end

    rg = weighted.flatten
    
    rg[Random.rand(rg.length)]
end
    
#get '/' do
#  
#end


puts "searching"

Twitter.user_timeline("#{ARGV[0]}").each do |status|
   addToCorpus(parseStatus(status.text))
end
puts CORPUS
puts "------------------------------------------"
for i in 1..20
    puts generate
    puts ""
end
