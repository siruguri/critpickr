$(document).ready(function(e) {
    $('.clickable_button').click(function(f) {
	$(this).css('background-color', 'black');
	$(this).css('color', 'white');
	t = $(this).text();

    });

    $('#movie_sortable').sortable(
	{update: function(e, ui) {
	    window.bl_comp.setState({text: 'a'});
	}});
});
