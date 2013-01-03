module RailsApplication
  module CustomSearch

    # Custom version of data bag search, to be used also in chef solo
    def data_bag_search bag, query = {}
      if Chef::Config[:solo]
        Chef::Log.info("This recipe uses search. Will use a restricted version of search")
        # retrieve all elements from the given databag
        all_items = data_bag(bag).map { |app| data_bag_item(bag, app) }
        all_items.select { |item| match_simple_query(item, query) }
      else
        search(bag, hash_query_to_string(query))
      end
    end

    # Iterate through elements
    def each_data_bag_item bag, query = {}, &block
      data_bag_search(bag, query).each { |item| block.call(item) }
    end

    private

    # Convert an hash to a lucene query, only simple queries are supported
    # at this time
    #
    # @param [String,Hash] query
    #
    # @return [String] a lucene query
    def hash_query_to_string query
      case query
        when Hash
          query.map { |k, v| "#{k}:#{v}" }.join(' AND ')
        when String
          query
        else
          raise ArgumentError, "Query must be string or hash, #{query.class} given"
      end
    end

    # Used in simple search with chef solo
    #
    # @param [Chef::DataBagItem] item
    # @param [Hash] query
    #
    # @return [Bool] true if this item match the query
    def match_simple_query item, query
      query.empty? || query.all? { |k, v|
        item["#{k}"] == v
      }
    end
  end
end

Chef::Recipe.send :include, RailsApplication::CustomSearch