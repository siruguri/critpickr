var Button = React.createClass({
  getInitialState: function() {
    return {id: this.props.payload.id, name: this.props.payload.name};
  },
  
  render: function() {
    this.state.clicked_count += 1;
    return (
      <li data-movie-id={this.state.id}>
      <div className='clickable_button btn btn-default'>
	{this.state.id}: {this.state.name}
      </div></li>
    );
  }
});

var ButtonList = React.createClass({
  is_sorted: function() {
    sorted = true;
    current_ids = [];

    dom_children = $(React.findDOMNode(this)).find('li');
    for(var i=0; i < dom_children.length; i++) {
      current_ids.push($(dom_children[i]).data('movie-id'));
    }
      
    for(var i=0; sorted && i < this.state.saved_sorting_order.length; i++) {
      if (this.state.saved_sorting_order[i] != current_ids[i]) {
	sorted = false;
      }
    }
    
    return sorted;
  },

  getInitialState: function() {
    return {isMounted: false, saved_sorting_order: this.props.list_data.map(function(item) {
      return item.id;
    })}
  },

  componentDidMount: function() {
    this.state.isMounted = true;
  },
  
  render: function() {
    var button_list = [];
    this.props.sorting_changed = !this.state.isMounted || !this.is_sorted();
    
    button_html = <div className='paragraph' sorting_changed={this.props.sorting_changed} ><ActiveSubmitter /></div>;
    
    for(var i=0; i < this.props.list_data.length; i++) {
      button_list.push(<Button ref={'buttonChild-' + i} payload={this.props.list_data[i]} />);
		 }

    actual_list =(<ol id='movie_sortable' className="buttonList">
      {button_list}
    </ol>);
    
    return (<div className='buttonList'>{button_html} {actual_list}</div>);
  }
});

var ActiveSubmitter = React.createClass({
  render: function() {
    is_disabled = this.props.sorting_changed;
    return (
      <button className='btn btn-default pull-right' disabled={is_disabled}>Submit!</button>
    );
  }
});

y=$('#content').data('movie-payload');

window.bl_comp = React.render(
  <ButtonList list_data={y} />,
  document.getElementById('content')
);
