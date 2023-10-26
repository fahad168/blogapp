import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    scroll () {
        var viewCurrentPage = localStorage.getItem('viewCurrentPage')
        var viewNextPage = parseInt(viewCurrentPage)
        viewNextPage += 1
        localStorage.setItem('viewCurrentPage', viewNextPage)
        const websiteURL = this.element.getAttribute('data-url');
        const dataGenreIds = this.element.getAttribute('data-genre-ids');
        let url = `${websiteURL}/specific_genre_movies`
        var csrfToken = $('meta[name="csrf-token"]').attr('content');
        $.ajax({
            type: 'POST',
            url: url,
            data: { authenticity_token: csrfToken, next_page: viewNextPage, genre_ids: dataGenreIds},
            dataType: 'json',
            success: (data) => {
                $('#viewModalData').append(data.entries)
            }
        })
    }
}
