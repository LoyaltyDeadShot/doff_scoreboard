// AUTHOR: DoFF - https://github.com/daroczi/doff_scoreboard
// 
// /$$$$$$$          /$$$$$$$$/$$$$$$$$        /$$$$$$                                     /$$                                       /$$
// | $$__  $$        | $$_____| $$_____/       /$$__  $$                                   | $$                                      | $$
// | $$  \ $$ /$$$$$$| $$     | $$            | $$  \__/ /$$$$$$$ /$$$$$$  /$$$$$$  /$$$$$$| $$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$$
// | $$  | $$/$$__  $| $$$$$  | $$$$$         |  $$$$$$ /$$_____//$$__  $$/$$__  $$/$$__  $| $$__  $$/$$__  $$|____  $$/$$__  $$/$$__  $$
// | $$  | $| $$  \ $| $$__/  | $$__/          \____  $| $$     | $$  \ $| $$  \__| $$$$$$$| $$  \ $| $$  \ $$ /$$$$$$| $$  \__| $$  | $$
// | $$  | $| $$  | $| $$     | $$             /$$  \ $| $$     | $$  | $| $$     | $$_____| $$  | $| $$  | $$/$$__  $| $$     | $$  | $$
// | $$$$$$$|  $$$$$$| $$     | $$            |  $$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$| $$$$$$$|  $$$$$$|  $$$$$$| $$     |  $$$$$$$
// |_______/ \______/|__/     |__/             \______/ \_______/\______/|__/      \_______|_______/ \______/ \_______|__/      \_______/
// 

let GlobalLevel = false;
let GlobalPing = true;

let Shop = false;
let ShopMin = 0;

let Bank = false;
let BankMin = 0;

$(function() {
	window.addEventListener('message', function(event) {
		switch (event.data.action) {
            case 'setupScoreboard':
                document.documentElement.style.setProperty('--bg', `${event.data.bg}`);
                document.documentElement.style.setProperty('--bg-top', `${event.data.top}`);
                document.documentElement.style.setProperty('--frame-color', `${event.data.frame}`);
                document.documentElement.style.setProperty('--list-background', `${event.data.list}`);
                document.documentElement.style.setProperty('--heading-bg', `${event.data.heading}`);
                document.documentElement.style.setProperty('--radius', `${event.data.radius}`);
				$('#server-name').html(event.data.serverName);

                let jobConfig = event.data.jobColumns;
                let mainKeys = Object.keys(jobConfig);
				$('.left-side').empty();
				$('.right-side').empty();

                Shop = event.data.shop;
                ShopMin = event.data.mshop;
                Bank = event.data.bank;
                BankMin = event.data.mbank;

                if (Bank == true) {
                    $('.right-side').append(`
                        <div class="job-box robbery-edit">
                            <div class="on" id="bank">
                                <span>🏦</span><span class="avaliable">✔️</span><span class="not-avaliable">❌</span>
                            </div>
                        </div>
                    `);
                }

                if (Shop == true) {
                    $('.right-side').append(`
                        <div class="job-box robbery-edit">
                            <div class="on" id="shop">
                                <span>🛍️</span><span class="avaliable">✔️</span><span class="not-avaliable">❌</span>
                            </div>
                        </div>
                    `);
                }

                for (let i = 0; i < mainKeys.length; i++) {
                    if (jobConfig[mainKeys[i]].align == 'left') {
                        $('.left-side').append(`
                            <div class="job-box">
                                <div class="on" id="${mainKeys[i]}">
                                    <span>${jobConfig[mainKeys[i]].emoji}</span><span class="avaliable">✔️</span><span class="not-avaliable">❌</span>
                                </div>
                            </div>
                        `);
                    } else if (jobConfig[mainKeys[i]].align == 'right') {
                        $('.right-side').append(`
                            <div class="job-box">
                                <div class="on" id="${mainKeys[i]}">
                                    <span>${jobConfig[mainKeys[i]].emoji}</span><span class="avaliable">✔️</span><span class="not-avaliable">❌</span>
                                </div>
                            </div>
                        `);
                    }
                }

                break;

			case 'enable':
				$('body').fadeIn();
				$('.main-frame').fadeIn(800);
				break;

			case 'uptime':
                $('#uptime').html(event.data.uptime);
				break;

            case 'close':
                $('body').fadeOut();
                $('.main-frame').fadeOut(800);
                break;

			case 'updatePlayerJobs':
				var jobs = event.data.jobs;
                Shop = event.data.shop;
                ShopMin = event.data.mshop;
                Bank = event.data.bank;
                BankMin = event.data.mbank;

				$('#currentplayer').html(event.data.player_count);
                let keys = Object.keys(jobs);

                for (let i = 0; i < keys.length; i++) {
                    // console.log("Lekért div: #" + keys[i]);
                    if (jobs[keys[i]] > 0) {
                        $(`#${keys[i]}`).removeClass("off");
                        $(`#${keys[i]}`).addClass("on");
                    } else {
                        $(`#${keys[i]}`).removeClass("on");
                        $(`#${keys[i]}`).addClass("off");
                    }    
                }
                
                if (Bank == true && BankMin <= jobs['police']) {
                    $(`#bank`).removeClass("off");
                    $(`#bank`).addClass("on");
                } else {
                    $(`#bank`).removeClass("on");
                    $(`#bank`).addClass("off");
                }

                if (Shop == true && ShopMin <= jobs['police']) {
                    $(`#shop`).removeClass("off");
                    $(`#shop`).addClass("on");
                } else {
                    $(`#shop`).removeClass("on");
                    $(`#shop`).addClass("off");
                }

				break;

			case 'updatePlayerList':
				$('.player-list').empty();
				$('.player-list').append(event.data.players);
				setPingColor();
				break;

			case 'updatePing':
				updatePing(event.data.players);
				setPingColor();
				break;

            case 'langSetup':
                    $('#player-lang').html(event.data.playerlang);
                    $('#playtime-lang').html(event.data.playtimelang);
                    $('#uptime-lang').html(event.data.uptimelang);
                    $('.heading-name').html(event.data.playernamelang);
                    $('.player-lvl-info').html(event.data.lvlpinglang);
                break;

			case 'updateServerInfo':
				if (event.data.maxPlayers) {
					$('#maxplayer').html(event.data.maxPlayers);
				}

				if (event.data.uptime) {
					$('#uptime').html(event.data.uptime);
				}

				if (event.data.playTime) {
					$('#playtime').html(event.data.playTime);
				}

				break;

			default:
				break;
		}
	});
});

function setPingColor() {
	$('.player-list').each(function() {
		$(this).find('.player-ping').each(function() {
            var ping = parseInt($(this).html());

			if (ping == 'missing') {
				$(this).css('color', 'orange');
			} else {
				var color = 'white';

				if (ping > 50 && ping < 80) {
					color = 'orange';
				} else if (ping >= 80) {
					color = 'red';
				}

				$(this).css('color', color);
				$(this).html(ping + " <span style='color:white;'>ms</span>");
			}
		});
	});
}

function updatePing(players) {
	$.each(players, function(index, element) {
		if (element != null) {
			$('.player-list').each(function() {
				$(this).find('.player-id:contains(' + element.playerId + ')').each(function() {
					$(this).parent().find('div').eq(4).html(element.ping);
				});
			});
		}
	});
    if (GlobalLevel == true) {
        $('.player-lvl').hide();
        $('.player-ping').show();
        GlobalLevel = false;
        GlobalPing = true;
    } else {
        $('.player-ping').hide();
        $('.player-lvl').show();
        GlobalLevel = true;
        GlobalPing = false;
    }
}