// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require rails-ujs
//= require bootstrap-sprockets

import "@hotwired/turbo-rails"
import "controllers"
// document.addEventListener('DOMContentLoaded', () => {
//     document.querySelectorAll('.toggle-availability').forEach(button => {
//       button.addEventListener('click', (event) => {
//         event.preventDefault();

//         const scheduleId = button.dataset.scheduleId;

//         // Ajaxリクエストでis_availableを切り替える
//         fetch(`/schedules/${scheduleId}/toggle_availability`, {
//           method: 'PATCH',
//           headers: {
//             'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
//             'Content-Type': 'application/json'
//           },
//           body: JSON.stringify({})
//         })
//         .then(response => response.json())
//         .then(data => {
//           // サーバーからのレスポンスに基づいて表示を切り替え
//           if (data.is_available) {
//             button.textContent = '◯';
//             button.style.color = '#4CAF50';
//           } else {
//             button.textContent = '✖️';
//             button.style.color = '#FF0000';
//           }
//         })
//         .catch(error => console.error('Error:', error));
//       });
//     });
//   });
