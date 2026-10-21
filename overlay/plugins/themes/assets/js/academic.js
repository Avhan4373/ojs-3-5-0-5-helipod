/**
 * Academic Theme for OJS 3.5
 * Frontend behaviour: back-to-top, navbar shadow, tooltips, citation copy and
 * the 12-month usage chart.
 */
(function () {
	'use strict';

	function onReady(fn) {
		if (document.readyState !== 'loading') {
			fn();
			return;
		}
		document.addEventListener('DOMContentLoaded', fn);
	}

	/* ------------------------------------------------------------------ *
	 * Back to top
	 * ------------------------------------------------------------------ */
	function initBackToTop() {
		var button = document.getElementById('acadBackToTop');
		if (!button) {
			return;
		}

		var toggle = function () {
			if (window.pageYOffset > 300) {
				button.classList.add('show');
			} else {
				button.classList.remove('show');
			}
		};

		window.addEventListener('scroll', toggle, { passive: true });
		toggle();

		button.addEventListener('click', function (event) {
			event.preventDefault();
			window.scrollTo({ top: 0, behavior: 'smooth' });
		});
	}

	/* ------------------------------------------------------------------ *
	 * Sticky navbar shadow
	 * ------------------------------------------------------------------ */
	function initNavbarShadow() {
		var navbar = document.querySelector('.acad-navbar');
		if (!navbar) {
			return;
		}

		var toggle = function () {
			if (window.pageYOffset > 10) {
				navbar.classList.add('is-scrolled');
			} else {
				navbar.classList.remove('is-scrolled');
			}
		};

		window.addEventListener('scroll', toggle, { passive: true });
		toggle();
	}

	/* ------------------------------------------------------------------ *
	 * Bootstrap tooltips
	 * ------------------------------------------------------------------ */
	function initTooltips() {
		if (typeof bootstrap === 'undefined' || !bootstrap.Tooltip) {
			return;
		}
		document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(function (element) {
			new bootstrap.Tooltip(element);
		});
	}

	/* ------------------------------------------------------------------ *
	 * Copy citation button (article page)
	 * ------------------------------------------------------------------ */
	function initCitationCopy() {
		document.addEventListener('click', function (event) {
			var button = event.target.closest('#copyCitationBtn');
			if (!button) {
				return;
			}
			event.preventDefault();

			var output = document.getElementById('citationOutput');
			if (!output) {
				return;
			}
			var text = output.textContent.trim();
			if (!text) {
				return;
			}

			var done = function () {
				var original = button.innerHTML;
				button.innerHTML = '<i class="bi bi-check-lg me-1"></i> Copied!';
				button.classList.add('btn-success');
				button.classList.remove('btn-outline-primary');
				setTimeout(function () {
					button.innerHTML = original;
					button.classList.remove('btn-success');
					button.classList.add('btn-outline-primary');
				}, 2000);
			};

			if (navigator.clipboard) {
				navigator.clipboard.writeText(text).then(done).catch(function () {});
				return;
			}

			var textarea = document.createElement('textarea');
			textarea.value = text;
			document.body.appendChild(textarea);
			textarea.select();
			try {
				document.execCommand('copy');
				done();
			} catch (error) {
				// Ignore.
			}
			textarea.remove();
		});
	}

	/* ------------------------------------------------------------------ *
	 * 12 month views/downloads chart
	 * ------------------------------------------------------------------ */
	var chartInstance = null;

	function readData(container, attribute) {
		if (!container) {
			return [];
		}
		try {
			return JSON.parse(container.getAttribute(attribute) || '[]');
		} catch (error) {
			return [];
		}
	}

	function initJournalChart() {
		var container = document.getElementById('acadJournalChartContainer');
		var canvas = document.getElementById('journal12mBarChart');
		if (!container || !canvas) {
			return;
		}

		if (typeof Chart === 'undefined') {
			// Chart.js may still be loading; retry briefly.
			var retries = 0;
			var retry = function () {
				if (typeof Chart !== 'undefined') {
					initJournalChart();
					return;
				}
				if (retries++ < 30) {
					setTimeout(retry, 100);
				}
			};
			retry();
			return;
		}

		var labels = readData(container, 'data-labels');
		var views = readData(container, 'data-views');
		var downloads = readData(container, 'data-downloads');

		if (chartInstance && typeof chartInstance.destroy === 'function') {
			chartInstance.destroy();
		}

		chartInstance = new Chart(canvas, {
			type: 'bar',
			data: {
				labels: labels,
				datasets: [
					{
						label: 'Views',
						data: views,
						backgroundColor: 'rgba(37, 99, 235, 0.85)',
						hoverBackgroundColor: '#1d4ed8',
						borderColor: '#2563eb',
						borderWidth: 1,
						borderRadius: 6,
						borderSkipped: false,
						barPercentage: 0.65,
						categoryPercentage: 0.65
					},
					{
						label: 'Downloads',
						data: downloads,
						backgroundColor: 'rgba(16, 185, 129, 0.85)',
						hoverBackgroundColor: '#047857',
						borderColor: '#10b981',
						borderWidth: 1,
						borderRadius: 6,
						borderSkipped: false,
						barPercentage: 0.65,
						categoryPercentage: 0.65
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				animation: { duration: 700 },
				interaction: { mode: 'index', intersect: false },
				plugins: {
					legend: {
						position: 'top',
						align: 'start',
						labels: {
							usePointStyle: true,
							pointStyle: 'circle',
							padding: 16,
							font: {
								size: 12,
								weight: '600',
								family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
							},
							color: '#334155'
						}
					},
					tooltip: {
						backgroundColor: 'rgba(15, 23, 42, 0.94)',
						titleFont: {
							size: 13,
							weight: '700',
							family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
						},
						bodyFont: {
							size: 12,
							weight: '500',
							family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
						},
						padding: 12,
						cornerRadius: 8,
						boxPadding: 6,
						usePointStyle: true,
						callbacks: {
							label: function (context) {
								return (context.dataset.label || '') + ': ' + new Intl.NumberFormat('id-ID').format(context.parsed.y);
							}
						}
					}
				},
				scales: {
					x: {
						grid: { display: false, drawBorder: false },
						ticks: {
							font: {
								size: 11,
								weight: '500',
								family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
							},
							color: '#64748b'
						}
					},
					y: {
						beginAtZero: true,
						grid: { color: 'rgba(226, 232, 240, 0.8)', drawBorder: false },
						ticks: {
							precision: 0,
							font: {
								size: 11,
								weight: '500',
								family: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
							},
							color: '#64748b',
							callback: function (value) {
								return new Intl.NumberFormat('id-ID').format(value);
							}
						}
					}
				}
			}
		});
	}

	window.filterJournalChart = function (mode) {
		if (!chartInstance) {
			return;
		}

		var buttons = {
			both: document.getElementById('btnFilterBoth'),
			views: document.getElementById('btnFilterViews'),
			downloads: document.getElementById('btnFilterDownloads')
		};

		Object.keys(buttons).forEach(function (key) {
			if (buttons[key]) {
				buttons[key].classList.remove('active');
			}
		});

		if (mode === 'views') {
			chartInstance.setDatasetVisibility(0, true);
			chartInstance.setDatasetVisibility(1, false);
			if (buttons.views) {
				buttons.views.classList.add('active');
			}
		} else if (mode === 'downloads') {
			chartInstance.setDatasetVisibility(0, false);
			chartInstance.setDatasetVisibility(1, true);
			if (buttons.downloads) {
				buttons.downloads.classList.add('active');
			}
		} else {
			chartInstance.setDatasetVisibility(0, true);
			chartInstance.setDatasetVisibility(1, true);
			if (buttons.both) {
				buttons.both.classList.add('active');
			}
		}

		chartInstance.update();
	};

	/* ------------------------------------------------------------------ *
	 * Article download chart (aggregated monthly counter data)
	 * ------------------------------------------------------------------ */
	function initArticleDownloadsChart() {
		var canvas = document.getElementById('acadArticleDownloadsChart');
		if (!canvas || typeof Chart === 'undefined') {
			return;
		}

		var chartData;
		try {
			chartData = JSON.parse(canvas.getAttribute('data-chart') || '{}');
		} catch (error) {
			return;
		}

		if (!chartData.labels || !chartData.downloads) {
			return;
		}

		new Chart(canvas, {
			type: 'bar',
			data: {
				labels: chartData.labels,
				datasets: [
					{
						label: 'Downloads',
						data: chartData.downloads,
						backgroundColor: 'rgba(22, 128, 61, 0.75)',
						borderColor: 'rgba(22, 128, 61, 1)',
						borderWidth: 1,
						borderRadius: 4,
						maxBarThickness: 28
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: { display: false },
					tooltip: {
						callbacks: {
							label: function (context) {
								return context.parsed.y + ' downloads';
							}
						}
					}
				},
				scales: {
					x: {
						grid: { display: false },
						ticks: { maxRotation: 0, autoSkip: true, font: { size: 10 } }
					},
					y: {
						beginAtZero: true,
						ticks: { precision: 0 }
					}
				}
			}
		});
	}

	/* ------------------------------------------------------------------ *
	 * Empty article download chart (core usage-stats-chart.js)
	 * ------------------------------------------------------------------ */
	function initUsageStatsFallback() {
		if (typeof pkpUsageStats === 'undefined' || !pkpUsageStats.data || !pkpUsageStats.data.Submission) {
			return;
		}

		document.querySelectorAll('canvas.usageStatsGraph').forEach(function (canvas) {
			var entry = pkpUsageStats.data.Submission[canvas.getAttribute('data-object-id')];
			if (!entry || !entry.total) {
				canvas.style.display = 'none';
				var unavailable = canvas.parentElement ? canvas.parentElement.querySelector('.usageStatsUnavailable') : null;
				if (unavailable) {
					unavailable.style.display = 'block';
				}
			}
		});
	}

	/* ------------------------------------------------------------------ *
	 * Password visibility toggles (login/register)
	 * ------------------------------------------------------------------ */
	function initPasswordToggles() {
		document.querySelectorAll('.toggle-password-btn').forEach(function (button) {
			button.addEventListener('click', function () {
				var selector = button.getAttribute('data-target');
				var input = selector ? document.querySelector(selector) : null;

				if (!input) {
					return;
				}

				var showPassword = input.getAttribute('type') === 'password';
				input.setAttribute('type', showPassword ? 'text' : 'password');
				button.setAttribute('aria-pressed', showPassword ? 'true' : 'false');

				var icon = button.querySelector('i');
				if (icon) {
					icon.classList.toggle('bi-eye', !showPassword);
					icon.classList.toggle('bi-eye-slash', showPassword);
				}
			});
		});
	}

	onReady(function () {
		initBackToTop();
		initNavbarShadow();
		initTooltips();
		initCitationCopy();
		initJournalChart();
		initArticleDownloadsChart();
		initPasswordToggles();

		// The core download chart is bootstrapped after this script, so wait
		// for the load event before collapsing empty charts.
		window.addEventListener('load', initUsageStatsFallback);
	});
})();
