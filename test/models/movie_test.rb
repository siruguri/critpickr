require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  def setup
    @model = movies(:entry_1)
  end
  test '#save_payload!' do
    assert_equal 0, Movie.find(@model.id).ratings.size
    @model.save_payload! rt_payload
    assert @model.persisted?
    
    assert_equal 2, Movie.find(@model.id).ratings.size
    assert_equal 10, MovieCritic.count

    assert_equal 10, MovieCriticRating.count
    assert_equal 1, MovieCritic.first.movie_critic_ratings.count
    assert_equal 'Dave Kehr', MovieCritic.first.name

    model = movies(:entry_2)

    model.save_payload! rt_payload_2
    assert model.persisted?
    
    assert_equal 20, MovieCriticRating.count
  end

  describe 'search' do
    it 'returns a list of movies' do
      assert_equal 2, Movie.search('Man').size
    end
  end

  private
  def rt_payload
    {:movie_name => 'ola ola', :allcrits_tomato_score=>["85"], :topcrits_tomato_score=>["50"], :critic_data=>[{:rating=>[" media-img icon small rotten"]}, {:rating=>[" media-img icon small rotten"], :name=>["Dave Kehr"]}, {:rating=>[" media-img icon small fresh"], :name=>["Geoff Andrew"]}, {:rating=>["Original Score: 9/10 media-img icon small fresh"], :name=>["Tim Brayton"]}, {:rating=>["Original Score: 5/5 media-img icon small fresh"], :name=>["Tony Sloman"]}, {:rating=>["Original Score: 4/5 media-img icon small fresh"], :name=>["Kevin Carr"]}, {:rating=>[" media-img icon small fresh"], :name=>["Sarah Crompton"]}, {:rating=>["Original Score: 4/5 media-img icon small fresh"]}, {:rating=>["Original Score: 5/5 media-img icon small fresh"], :name=>["Nell Minow"]}, {:rating=>["Original Score: 4/4 media-img icon small fresh"], :name=>["Peter Canavese"]}, {:rating=>["Original Score: 10/10 media-img icon small fresh"], :name=>["James Plath"]}, {:rating=>["Original Score: B media-img icon small fresh"], :name=>["Dennis Schwartz"]}], :ratings=>["85", "50"]}
  end

  def rt_payload_2
    {:movie_name => 'ola ola 2', :allcrits_tomato_score=>["85"], :topcrits_tomato_score=>["50"], :critic_data=>[{:rating=>[" media-img icon small rotten"]}, {:rating=>[" media-img icon small rotten"], :name=>["Dave Kehr"]}, {:rating=>[" media-img icon small fresh"], :name=>["Geoff Andrew"]}, {:rating=>["Original Score: 9/10 media-img icon small fresh"], :name=>["Tim Brayton"]}, {:rating=>["Original Score: 5/5 media-img icon small fresh"], :name=>["Tony Sloman"]}, {:rating=>["Original Score: 4/5 media-img icon small fresh"], :name=>["Kevin Carr"]}, {:rating=>[" media-img icon small fresh"], :name=>["Sarah Crompton"]}, {:rating=>["Original Score: 4/5 media-img icon small fresh"]}, {:rating=>["Original Score: 5/5 media-img icon small fresh"], :name=>["Nell Minow"]}, {:rating=>["Original Score: 4/4 media-img icon small fresh"], :name=>["Peter Canavese"]}, {:rating=>["Original Score: 10/10 media-img icon small fresh"], :name=>["James Plath"]}, {:rating=>["Original Score: B media-img icon small fresh"], :name=>["Dennis Schwartz"]}], :ratings=>["85", "50"]}
  end
end
