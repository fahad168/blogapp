import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    get_more_search_data() {
        var body = document.body,
            html = document.documentElement
        var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight)
        if (window.pageYOffset >= height - window.innerHeight) {
            var loader = document.getElementById('loader-container1')
            loader.style.display = "flex"
            let type = $('.search_type')[0].value
            var movie_genre = $('.movie_genre')[0].value
            var tv_genre = $('.tv_genre')[0].value
            var language = $('.language')[0].value
            var year = $('.year')[0].value
            var sort_by = $('.sort_by')[0].value
            if (type === 'Select Type' && movie_genre === 'Select Movie Genre' && tv_genre === 'Select Tv Genre' && language === 'Select Language' && year === 'Choose year' && sort_by === 'Sort' ) {
                var index_page = localStorage.getItem('index_page')
                index_page = parseInt(index_page) + 1
                localStorage.setItem('index_page', `${index_page}`)
                let simple_url = `/browse?page=${index_page}`
                this.method_cal(simple_url, loader)
            } else {
                if (type === 'Select Type') {
                    var filter_page = localStorage.getItem('filter_page')
                    filter_page = parseInt(filter_page) + 1
                    localStorage.setItem('index_page', `${filter_page}`)
                    let simple_url = `/browse?page=${filter_page}`
                    this.method_cal(simple_url, loader)
                } else {
                    var scroll_filter_page = localStorage.getItem('scroll_filter_page')
                    scroll_filter_page = parseInt(scroll_filter_page) + 1
                    localStorage.setItem('scroll_filter_page', `${scroll_filter_page}`)
                    let url = `/browse?type=${type}&page=${scroll_filter_page}`
                    if (movie_genre !== 'Select Movie Genre' ) {
                        url = `${url}&genre_id=${movie_genre}`
                    }
                    if (tv_genre !== 'Select Tv Genre' ) {
                        url = `${url}&genre_id=${tv_genre}`
                    }
                    if (language !== 'Select Language' ) {
                        url = `${url}&language=${language}`
                    }
                    if (year !== 'Choose year') {
                        url = `${url}&year=${year}`
                    }
                    if (sort_by !== 'Sort' ) {
                        url = `${url}&sort_by=${sort_by}`
                    }
                    this.method_cal(url, loader)
                }
            }
        }
    }

    method_cal (url, loader) {
        $.ajax({
            type: 'GET',
            url: url,
            dataType: 'json',
            success: (data) => {
                $('#advance_search_data').append(data.entries)
                loader.style.display = "none"
            }
        })
    }
}
