require 'test_helper'
require 'yaml'
class PathTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should create a path sucessfully" do
  	
  	set = {:cat => 
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

  	path = Path.create(structure: set)
  	assert_equal path.structure, set

  	Path.all


  end
end
