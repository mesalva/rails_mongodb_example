class TestMqController < ApplicationController
  def test
  	MESSAGING_SERVICE.publish({key: "value"})
  	render :json => {key: "value"}
  end
end
