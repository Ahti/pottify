require 'opal'
require 'reactive-ruby'

require 'js/native_components'
require 'js/semantic_helper'
require 'js/counter'

require 'browser'
require 'browser/http'

require 'vienna'

require 'js/components/feed_list'
require 'js/components/feed_list_item'

require 'js/components/feed_page'

require 'js/models/feed_model'

React.render(React.create_element(Semantic::ActiveLoader), `document.getElementById('app-root')`)

router = Vienna::Router.new

Browser::HTTP.get "/feeds" do
  on :success do |res|
    feeds = FeedListModel.deserialize(res.json)
    React.render(React.create_element(Pottify::List, feeds: feeds), `document.getElementById('app-root')`)
  end
end

router.route("/feeds/:id") do |params|
  React.render(React.create_element(Semantic::ActiveLoader), `document.getElementById('app-root')`)
  Browser::HTTP.get "/feeds/" + params[:id] do
    on :success do |res|
      feed = FeedModel.deserialize(res.json)
      React.render(React.create_element(Pottify::FeedPage, model: feed), `document.getElementById('app-root')`)
    end
  end
end

router.update
