$(document).ready(function () {
    localStorage.setItem('scroll_time', '0')
    var texture_count = localStorage.getItem('texture_count')
    if (texture_count && parseInt(texture_count) < 10) {
        texture_count = parseInt(texture_count) + 1
        localStorage.setItem('texture_count', `${texture_count}`)
    } else if (texture_count && parseInt(texture_count) === 10) {
        localStorage.setItem('texture_count', '1')
    } else {
        localStorage.setItem('texture_count', '1')
    }
    document.querySelectorAll('#texting').forEach(function (image) {
        image.style.backgroundImage = `url(/assets/textures/text_texture${texture_count}.jpg)`
    })
})

function open_movie(tmdb_id) {
    var dynamicUrl = `https://moviesapi.club/movie/${tmdb_id}`;
    var iframe = document.getElementById('movieIframe');
    iframe.src = dynamicUrl;
    document.getElementById('moviePlayModal').style.display = "flex"
}

function hideMovie() {
    document.getElementById('movieIframe').src = ""
    document.getElementById('moviePlayModal').style.display = "none"
}

function openModal(tmdb_id, season_number, episode_number) {
    var dynamicUrl = `https://moviesapi.club/tv/${tmdb_id}-${season_number}-${episode_number}`;
    var iframe = document.getElementById('episodeIframe');
    iframe.src = dynamicUrl;
    document.getElementById('episodeModal').style.display = "flex"
}

function hideEpisode() {
    document.getElementById('episodeIframe').src = ""
    document.getElementById('episodeModal').style.display = "none"
}
