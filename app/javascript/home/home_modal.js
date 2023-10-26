$(document).ready(function () {
    $('.single-item').slick({
        autoplay: true,
        autoplaySpeed: 2000,
        arrows: false
    })
    $('.nice-select').niceSelect()
    localStorage.setItem('page', 1)
})

function hideModal() {
    $('#movieModal').hide()
    document.getElementById('indexFile').style.overflow = ''
    $('#overlay').hide();
}

function hideSeasonModal() {
    $('#seasonModal').hide()
    document.getElementById('indexFile').style.overflow = ''
    $('#overlay').hide();
}

function get_episode_details() {
    const loaderContainer = document.getElementById("loader-container");
    loaderContainer.style.display = "flex";
    const seriesId = document.getElementById('season_id').value
    var seasonNo = document.getElementById('season_select').value
    var csrfToken = $('meta[name="csrf-token"]').attr('content');
    $.ajax({
        type: 'POST',
        url: '/episodes_details',
        data: { seriesId: seriesId, seasonNo: seasonNo, authenticity_token: csrfToken },
        success: function (response) {
            var modal = $('#episodes')
            modal.empty()
            modal.append(response.entries)
            loaderContainer.style.display = "none";
        }
    })
}
