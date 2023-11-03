$(document).ready(function () {
    $('.single-item').slick({
        autoplay: true,
        autoplaySpeed: 2000,
        arrows: false
    })
    $('.nice-select').niceSelect()
    localStorage.setItem('page', 1)
})

function hideSeasonModal() {
    $('#seasonModal').hide()
    document.getElementById('indexFile').style.overflow = ''
    $('#overlay').hide();
}
