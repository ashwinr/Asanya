function init()
{
	$('#next').css('width', 50);
	$('#next').css('height', 50);
	$('#next').click(handle_click);

	$(window).resize(handle_resize);
	handle_resize();
}

function handle_resize()
{
	var ruContainer = $('#ru-container'), enContainer = $('#en-container');
	var ruText = $('#ru-txt'), enText = $('#en-txt');
	
	ruText.css('font-size', ruContainer.height() * 6/10);
	enText.css('font-size', enContainer.height() * 6/10);

	var ruTextWidth = ruText.width(), enTextWidth = enText.width();
	var ruFontSize = parseFloat(ruText.css('font-size'));
	var enFontSize = parseFloat(enText.css('font-size'));
	
	while(ruTextWidth >= ruContainer.width())
	{
		ruFontSize = ruFontSize - 24;
		ruText.css('font-size',  ruFontSize);
		ruTextWidth = ruText.width();
	}

	while(enTextWidth >= enContainer.width())
	{
		enFontSize = enFontSize - 24;
		enText.css('font-size',  enFontSize);
		enTextWidth = enText.width();
	}

	$('#next').css('left', $(window).width() / 2  - $('#next').width() / 2);
	$('#next').css('top',  $(window).height() / 2 - $('#next').height() / 2);
}

function handle_click()
{
	$.get('/next', handle_next);
}

function handle_next(data)
{
	$('#ru-txt').animate({opacity: 0}, 100, function() {
		$(data).find('russian').each(function() { $('#ru-txt').html($(this).text()); });
		handle_resize();
		$('#ru-txt').animate({opacity: 1});
	});

	$('#en-txt').animate({opacity: 0}, 100, function() {
		$(data).find('english').each(function() { $('#en-txt').html($(this).text()); });
		handle_resize();
		$('#en-txt').animate({opacity: 1});
	});
}

$(document).ready(init);
