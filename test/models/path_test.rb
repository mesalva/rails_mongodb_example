require 'test_helper'
require 'yaml'
class PathTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
  	@set = {:cat => 
  			{1 => 
  				{:curso => 
  					{2 => 
  						{:modulo => 
  							{1 => 
  								{:aula => 
  									{1 => 
  										{:exercicio => [1,2,3]}
  									}
  								}
  							}
  						}
  					}
  				},
  				2 => {:curso => 
  					{2 => 
  						{:modulo => 
  							{1 => 
  								{:aula => 
  									{1 => 
  										{:exercicio => [1,2,3]}
  									}
  								}
  							}
  						}
  					}
  				}
  			}

  		  }
  end

  test "should create a path sucessfully" do

  	path = Path.create(structure: @set)
  	assert_equal path.structure, @set
  end

  test "should recreate a path sucessfully" do
  	path = Path.create(structure: @set)
  	assert_equal path.structure, @set

  	path = Path.create(structure: @set)
  	assert_equal path.structure, @set

  	assert_equal Path.count, 1
  end

  test "should merge a path sucessfully" do
	path = Path.create(structure: @set)
  	assert_equal path.structure, @set

  	uset = @set.merge({:teste => 1})

  	path.update(structure: uset)
  	assert_equal path.structure, uset
  end


end
