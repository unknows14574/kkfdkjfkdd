//Cinématique
function ShowCinema(IsEnable) {
	if (IsEnable) {
		$("#ShowCinema").show();
	}
	else {
		$("#ShowCinema").hide();
	}
};

//Progress Bar
function ProgressBar(IsEnable, text, time, options) {
	if (IsEnable) {
		$('#text').html(text)
		$('#wrapper').fadeIn(300)
		$('.bar').removeAttr('style')
		if (options) {
			if (options.color)
				$('.bar').css('background-color', options.color)
			if (options.customCSS)
				$('.bar').css(options.customCSS)
		}
		$('.bar').stop().css({ width: '0px' }).animate({
			width: '98%',
		}, time, 'linear',
			function () {
				$('#wrapper').fadeOut(600)
			});
	}
	else {
		$('#wrapper').hide();
	}
};
function DisplayImageSimCrack(srcImg) {
	var img = new Image();
    img.onload = function() {
		if (this.width > this.height) {
			$('#imgContainer').width('80%');
			$('#imgContainer').height('auto');			
		} else {
			$('#imgContainer').height('80%');
			$('#imgContainer').width('auto');			
		}
		$('#imgContainer').attr('src', srcImg)
		$('#displayImg').fadeIn(300)
    };
    img.src = srcImg;
}

function hideDisplayImageSimCrack() {
	$('#displayImg').fadeOut(300)
}

var audioPlayer = null;

$(function () {
	window.onload = (e) => {
		window.addEventListener('message', (event) => {
			//Cinematique
			if(event.data.openCinema == true || event.data.openCinema == false) {
					ShowCinema(event.data.openCinema);
				}

			//Progress Bar
			if(event.data.IsProgressBar == true || event.data.IsProgressBar == false) {
					ProgressBar(event.data.IsProgressBar, event.data.text, event.data.time, event.data.options);
				}
		
			//claque
			if (event.data.DemarrerLaMusique == "DemarrerLaMusique") {
				if (audioPlayer != null) {
					audioPlayer.pause();
				}
				audioPlayer = new Audio("./sound/Giffle.ogg");
				audioPlayer.volume = event.data.VolumeDeLaMusique;
				audioPlayer.play();
			}

			//Sim crack display image
			if (event.data.srcImage !== null && event.data.srcImage !== undefined && event.data.srcImage !== '') {
				DisplayImageSimCrack(event.data.srcImage);
			} else if(event.data.srcImage === '') {
				hideDisplayImageSimCrack();
			}
		});
	};
});