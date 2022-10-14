require "http"

class NodeApi

  BASE_URI = 'https://nodes-on-nodes-challenge.herokuapp.com/nodes/'

  def initialize
    @node_ids = {}
  end

  def fetch(ids)
    add_nodes(ids)
    response = HTTP.get(BASE_URI + ids.join(','))
    parsed_response = response.parse

    child_node_ids = parsed_response.map{|x| x['child_node_ids']}.flatten
    if child_node_ids.length > 0
      add_nodes(child_node_ids)
      fetch(child_node_ids)
    else
      puts "unique_node_ids:"
      puts @node_ids.keys
      puts "most_common_id:"
      puts @node_ids.key(@node_ids.values.max)
      return
    end

  end

  def add_nodes(ids)
    ids.each do |id|
      if @node_ids.has_key? id
        @node_ids[id] += 1
      else
        @node_ids[id] = 1
      end
    end
  end
end


node_api = NodeApi.new
node_api.fetch(['089ef556-dfff-4ff2-9733-654645be56fe'])
