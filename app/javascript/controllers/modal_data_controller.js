import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ['movieData']
    get_movie_data() {
        const loaderContainer = document.getElementById("loader-container");
        loaderContainer.style.display = "flex";
        const movieId = this.element.getAttribute('data-movie-id');
        $.ajax({
            type: 'GET',
            url: `/get_modal_data?movie_id=${movieId}`,
            dataType: 'json',
            success: (data) => {
                var modal = $('#movieInnerModal')
                modal.empty()
                modal.append(data.entries)
                document.getElementById('movieModal').style.display = 'flex'
                document.getElementById('movieModal').style.justifyContent = 'center'
                // document.getElementById('indexFile').style.overflow = 'hidden'
                $('#overlay').show();
                loaderContainer.style.display = "none";
            }
        })
    }

    get_season_data() {
        const loaderContainer = document.getElementById("loader-container");
        loaderContainer.style.display = "flex";
        const seasonId = this.element.getAttribute('data-season-id');
        $.ajax({
            type: 'GET',
            url: `/get_season_details?season_id=${seasonId}`,
            dataType: 'json',
            success: (data) => {
                var modal = $('#seasonInnerModal')
                modal.empty()
                modal.append(data.entries)
                $('.nice-select').niceSelect()
                document.getElementById('seasonModal').style.display = 'flex'
                document.getElementById('seasonModal').style.justifyContent = 'center'
                // document.getElementById('indexFile').style.overflow = 'hidden'
                $('#overlay').show();
                loaderContainer.style.display = "none";
            }
        })
    }

    scroll() {
        // var current_page = document.getElementById('current_page')
        // let next_page
        // if (current_page.value === '') {
        //     next_page = 2
        // } else {
        //     next_page = parseInt(current_page.value) + 1
        // }
        // current_page.value = next_page.toString()
        var body = document.body,
            html = document.documentElement
        var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)

        if (window.pageYOffset >= height - window.innerHeight) {
            var current_page = localStorage.getItem('page')
            var next_page = parseInt(current_page)
            next_page += 1
            localStorage.setItem('page', next_page)
            let url = `${window.location.href}&next_page=${next_page}`
            $.ajax({
                type: 'GET',
                url: url,
                dataType: 'json',
                success: (data) => {
                    $('#view_results').append(data.entries)
                }
            })
        }
    }

    movies_scroll() {
        var body = document.body,
            html = document.documentElement
        var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)

        if (window.pageYOffset >= height - window.innerHeight - 200) {
            const loaderContainer = document.getElementById("genre_loader");
            loaderContainer.style.display = "flex";
            var scrollTime = localStorage.getItem('scroll_time')
            var nextScroll = parseInt(scrollTime) + 1
            localStorage.setItem('scroll_time', nextScroll.toString())
            let url = `${window.location.href}?next_scroll=${nextScroll}`
            $.ajax({
                type: 'GET',
                url: url,
                dataType: 'json',
                success: (data) => {
                    $('#indexFile').append(data.entries)
                    loaderContainer.style.display = "none";
                }
            })
        }
    }
}
