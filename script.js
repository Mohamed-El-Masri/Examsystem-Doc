document.addEventListener('DOMContentLoaded', function() {
    initializeAll();
});

function initializeAll() {
    // Initialize components
    initializeSidebar();
    initializeSearch();
    initializeTheme(); // Keep only ONE call to this function
    initializeContent();
    initializeScrollHandlers();
    initializeBackToTop();
    initializeTOC();
    
    // Add responsive TOC toggle for mobile
    initializeResponsiveTOC();
    
    // Add proper table wrapping
    makeTablesResponsive();
    
    // Fix sidebar behavior on mobile
    initializeMobileSidebar();
    enhanceHeadingScrolling();
    
    // Add this line to call the new function
    improveScrollBehavior();
    
    // Add new responsive enhancements
    enhanceResponsiveness();
}

function initializeSidebar() {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    const main = document.getElementById('main');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('active');
            main.classList.toggle('sidebar-active');
            
            // When sidebar is shown in mobile, also show the TOC
            if (sidebar.classList.contains('active') && window.innerWidth < 768) {
                const tocBody = document.querySelector('.toc-body');
                if (tocBody) {
                    tocBody.classList.remove('d-none');
                    tocBody.classList.add('d-block');
                }
            }
        });
    }

    // Close sidebar when clicking outside
    document.addEventListener('click', (e) => {
        if (window.innerWidth < 768) {
            if (!sidebar?.contains(e.target) && 
                !sidebarToggle?.contains(e.target) && 
                sidebar?.classList.contains('active')) {
                sidebar.classList.remove('active');
                main.classList.remove('sidebar-active');
            }
        }
    });

    // Improve smooth scroll functionality
    const navLinks = document.querySelectorAll('.nav-links a, .nav-item a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(event) {
            // Mark as active
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
            
            // Smooth scroll with proper offset
            const targetId = this.getAttribute('href');
            if (targetId && targetId.startsWith('#')) {
                const target = document.querySelector(targetId);
                if (target) {
                    event.preventDefault();
                    
                    // Calculate proper scroll offset based on screen size
                    let offset = 60;
                    if (window.innerWidth < 768) {
                        offset = 80; // More offset on mobile for better visibility
                    }
                    
                    const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - offset;
                    
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });
                    
                    // Update URL without scrolling (pushState doesn't cause scrolling)
                    history.pushState(null, null, targetId);
                }
            }
        });
    });
}

// ONLY ONE theme function - remove the duplicates
function initializeTheme() {
    const themeToggle = document.querySelector('.theme-toggle');
    if (!themeToggle) return;

    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    
    function setTheme(isDark) {
        document.documentElement.classList.toggle('dark-theme', isDark);
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    }

    themeToggle.addEventListener('click', () => {
        const isDark = document.documentElement.classList.toggle('dark-theme');
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });

    // Initialize theme
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
        setTheme(savedTheme === 'dark');
    } else {
        setTheme(prefersDark.matches);
    }
}

function initializeSearch() {
    const searchContainer = document.querySelector('.search-container');
    const searchInput = searchContainer?.querySelector('input');
    const searchResults = searchContainer?.querySelector('.search-results');

    if (!searchInput || !searchResults) return;

    searchInput.addEventListener('input', debounce((e) => {
        const searchText = e.target.value;
        if (searchText.length >= 2) {
            performSearch(searchText, searchResults);
        } else {
            searchResults.innerHTML = '';
        }
    }, 300));
}

function performSearch(searchText, resultsContainer) {
    const content = document.getElementById('content');
    if (!content) return;

    const results = [];
    
    // Search in headers and paragraphs
    const searchables = content.querySelectorAll('h1, h2, h3, h4, h5, h6, p');
    
    searchables.forEach(element => {
        const text = element.textContent;
        if (text.toLowerCase().includes(searchText.toLowerCase())) {
            results.push({ element, text });
        }
    });
    
    resultsContainer.innerHTML = '';
    
    if (results.length > 0) {
        results.forEach(result => {
            const div = document.createElement('div');
            div.className = 'search-item';
            div.textContent = result.text.substring(0, 100) + (result.text.length > 100 ? '...' : '');
            div.addEventListener('click', () => {
                result.element.scrollIntoView({ behavior: 'smooth' });
                highlightElement(result.element);
                resultsContainer.innerHTML = '';
            });
            resultsContainer.appendChild(div);
        });
    } else {
        const div = document.createElement('div');
        div.className = 'search-item';
        div.textContent = 'No results found';
        resultsContainer.appendChild(div);
    }
}

function highlightElement(element) {
    element.style.backgroundColor = '#fff3cd';
    setTimeout(() => {
        element.style.backgroundColor = '';
    }, 2000);
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func.apply(this, args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Initialize content and TOC
function initializeContent() {
    // If using fetch to load content
    const contentElement = document.getElementById('content');
    if (!contentElement) return;
    
    // Check if we need to load content from markdown
    if (contentElement.dataset.source) {
        fetch(contentElement.dataset.source)
            .then(response => response.text())
            .then(text => {
                // Handle different versions of marked.js
                if (typeof marked !== 'undefined') {
                    try {
                        // Try the newer marked.parse() syntax
                        if (typeof marked.parse === 'function') {
                            contentElement.innerHTML = marked.parse(text);
                        } 
                        // Fall back to the older marked() syntax
                        else if (typeof marked === 'function') {
                            contentElement.innerHTML = marked(text);
                        } 
                        // If neither works, just display the raw text
                        else {
                            contentElement.innerHTML = text;
                            console.warn('Marked library available but not usable as a function');
                        }
                    } catch (err) {
                        console.error('Error parsing Markdown:', err);
                        contentElement.innerHTML = text;
                    }
                } else {
                    // If marked isn't available at all, just display the text
                    contentElement.innerHTML = text;
                    console.warn('Marked library not loaded');
                }
                
                // Initialize components that depend on content
                if (typeof Prism !== 'undefined') Prism.highlightAll();
                initializeTOC();
                enhanceCodeBlocks();
                enhanceHeadingScrolling();
                
                // Handle hash in URL for direct section loading
                if (window.location.hash) {
                    setTimeout(() => {
                        const targetElement = document.querySelector(window.location.hash);
                        if (targetElement) {
                            const offset = 80;
                            const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - offset;
                            
                            window.scrollTo({
                                top: targetPosition,
                                behavior: 'smooth'
                            });
                        }
                    }, 300); // Give a small delay for content to render fully
                }
            })
            .catch(error => {
                console.error('Error loading documentation:', error);
                contentElement.innerHTML = '<p>Error loading content. Please try again later.</p>';
            });
    } else {
        // For pre-loaded content
        contentSuccessHandler();
    }
}

// Scroll functionality
function initializeScrollHandlers() {
    // Enhanced Reading Progress indicator 
    const progressBar = document.querySelector('.reading-progress');
    if (progressBar) {
        // More accurate reading progress calculation
        const calculateProgress = () => {
            const docElement = document.documentElement;
            const contentWrapper = document.querySelector('.documentation-content');
            
            if (!contentWrapper) return 0;
            
            // Get viewport height
            const windowHeight = window.innerHeight;
            
            // Get total scrollable height of the content
            const contentBox = contentWrapper.getBoundingClientRect();
            const contentHeight = contentBox.height;
            const contentTop = contentBox.top + window.scrollY;
            const contentBottom = contentTop + contentHeight;
            
            // Calculate how much has been scrolled
            const scrollTop = window.scrollY;
            const visibleContentHeight = windowHeight;
            
            // Define start and end points for progress calculation
            const startPoint = contentTop - visibleContentHeight;
            const endPoint = contentBottom - visibleContentHeight;
            const progressDistance = endPoint - startPoint;
            
            // Calculate current position within that range
            let currentPosition = scrollTop - startPoint;
            
            // Ensure progress is between 0 and 100
            let progress = Math.max(0, Math.min(100, (currentPosition / progressDistance) * 100));
            
            return progress;
        };
        
        // Initial calculation
        progressBar.style.width = `${calculateProgress()}%`;
        
        // Use requestAnimationFrame for smoother updates
        let ticking = false;
        
        window.addEventListener('scroll', () => {
            if (!ticking) {
                window.requestAnimationFrame(() => {
                    progressBar.style.width = `${calculateProgress()}%`;
                    ticking = false;
                });
                ticking = true;
            }
        });
        
        // Recalculate on window resize
        window.addEventListener('resize', debounce(() => {
            progressBar.style.width = `${calculateProgress()}%`;
        }, 100));
    }
    
    // Enhanced scroll spy for navigation with intersection observer
    const navLinks = document.querySelectorAll('.nav-links a, .nav-item a');
    const sections = document.querySelectorAll('section[id], [id^="heading-"]');
    
    if (sections.length > 0 && 'IntersectionObserver' in window) {
        const observerOptions = {
            rootMargin: '-100px 0px -80% 0px',
            threshold: 0
        };
        
        const observerCallback = (entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    // Get the ID of the section that is currently visible
                    const id = entry.target.getAttribute('id');
                    
                    // Remove active class from all links
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === `#${id}`) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        };
        
        const observer = new IntersectionObserver(observerCallback, observerOptions);
        sections.forEach(section => {
            observer.observe(section);
        });
    } else {
        // Fallback to traditional scroll event if IntersectionObserver is not available
        window.addEventListener('scroll', debounce(function() {
            const scrollPos = window.scrollY;
            
            sections.forEach(section => {
                const top = section.offsetTop - 120;
                const bottom = top + section.offsetHeight;
                
                if (scrollPos >= top && scrollPos <= bottom) {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === `#${section.id}`) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        }, 100));
    }
}

// Enhanced Back to Top functionality
function initializeBackToTop() {
    const backToTopElement = document.querySelector('.back-to-top');
    if (!backToTopElement) {
        // Create back to top button if it doesn't exist
        const btn = document.createElement('button');
        btn.className = 'back-to-top';
        btn.innerHTML = '<i class="fas fa-arrow-up"></i>';
        document.body.appendChild(btn);
        
        window.addEventListener('scroll', debounce(function() {
            if (window.scrollY > 300) {
                btn.classList.add('show');
            } else {
                btn.classList.remove('show');
            }
        }, 100));
        
        btn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    } else {
        // Use existing button
        window.addEventListener('scroll', debounce(function() {
            if (window.scrollY > 300) {
                backToTopElement.classList.add('show');
            } else {
                backToTopElement.classList.remove('show');
            }
        }, 100));
        
        backToTopElement.addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
}

// Updated TOC initialization to use it as main navigation
function initializeTOC() {
    const tocElement = document.getElementById('toc');
    if (!tocElement) return;

    if (typeof tocbot !== 'undefined') {
        tocbot.init({
            tocSelector: '#toc',
            contentSelector: '.documentation-content',
            headingSelector: 'h2, h3, h4',
            hasInnerContainers: true,
            collapseDepth: 4,  // Show more levels by default
            scrollSmooth: true,
            scrollSmoothDuration: 400,
            scrollSmoothOffset: -80,
            headingsOffset: 100,
            includeTitleTags: true,
            orderedList: false,
            linkClass: 'toc-link',
            extraLinkClasses: '',
            activeLinkClass: 'is-active-link',
            listClass: 'toc-list',
            extraListClasses: '',
            listItemClass: 'toc-list-item',
            activeListItemClass: 'is-active-li',
            isCollapsedClass: 'is-collapsed',
            fixedSidebarOffset: 'auto',
        });
        
        // Add "active" class to parent elements of active links
        const activateTOCParents = () => {
            const activeLink = document.querySelector('.is-active-link');
            if (activeLink) {
                let parent = activeLink.parentElement;
                while (parent && parent.classList.contains('toc-list-item')) {
                    parent.classList.add('is-active-li');
                    parent = parent.parentElement?.parentElement; // Skip the ul and go to li
                }
            }
        };
        
        // Call initially
        activateTOCParents();
        
        // Call when scrolling
        window.addEventListener('scroll', debounce(activateTOCParents, 100));
    } else {
        // Simple TOC generation if tocbot isn't available
        const headings = document.querySelectorAll('.documentation-content h2, .documentation-content h3, .documentation-content h4');
        const tocList = document.createElement('ul');
        
        const headingsByLevel = {
            2: { list: tocList, items: {} },
            3: { items: {} },
            4: { items: {} }
        };
        
        headings.forEach(heading => {
            const level = parseInt(heading.tagName.charAt(1));
            const id = heading.id || heading.textContent.toLowerCase().replace(/[^a-z0-9]+/g, '-');
            heading.id = id;
            
            const item = document.createElement('li');
            const link = document.createElement('a');
            link.href = `#${id}`;
            link.textContent = heading.textContent;
            link.classList.add('toc-link');
            item.classList.add('toc-list-item');
            item.appendChild(link);
            
            if (level === 2) {
                headingsByLevel[2].list.appendChild(item);
                headingsByLevel[2].items[id] = item;
                headingsByLevel[3].items = {}; // Reset level 3
                headingsByLevel[4].items = {}; // Reset level 4
            } else if (level === 3) {
                const parentId = getParentHeadingId(heading, 2);
                if (parentId && headingsByLevel[2].items[parentId]) {
                    let subList = headingsByLevel[2].items[parentId].querySelector('ul');
                    if (!subList) {
                        subList = document.createElement('ul');
                        subList.classList.add('toc-list');
                        headingsByLevel[2].items[parentId].appendChild(subList);
                    }
                    subList.appendChild(item);
                    headingsByLevel[3].items[id] = item;
                    headingsByLevel[4].items = {}; // Reset level 4
                } else {
                    headingsByLevel[2].list.appendChild(item);
                }
            } else if (level === 4) {
                const parentId = getParentHeadingId(heading, 3);
                if (parentId && headingsByLevel[3].items[parentId]) {
                    let subList = headingsByLevel[3].items[parentId].querySelector('ul');
                    if (!subList) {
                        subList = document.createElement('ul');
                        subList.classList.add('toc-list');
                        headingsByLevel[3].items[parentId].appendChild(subList);
                    }
                    subList.appendChild(item);
                } else {
                    const parentL2Id = getParentHeadingId(heading, 2);
                    if (parentL2Id && headingsByLevel[2].items[parentL2Id]) {
                        let subList = headingsByLevel[2].items[parentL2Id].querySelector('ul');
                        if (!subList) {
                            subList = document.createElement('ul');
                            subList.classList.add('toc-list');
                            headingsByLevel[2].items[parentL2Id].appendChild(subList);
                        }
                        subList.appendChild(item);
                    } else {
                        headingsByLevel[2].list.appendChild(item);
                    }
                }
            }
        });
        
        tocList.classList.add('toc-list');
        tocElement.appendChild(tocList);
        
        // Add active class on scroll
        window.addEventListener('scroll', debounce(function() {
            activateTOCItem(headings, tocElement);
        }, 100));
    }
    
    // Add click handler for all TOC links
    document.querySelectorAll('#toc a').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const target = document.querySelector(targetId);
            if (target) {
                // Calculate offset based on device
                let offset = 80;
                if (window.innerWidth < 768) {
                    offset = 100;
                }
                
                const targetPosition = target.getBoundingClientRect().top + window.scrollY - offset;
                
                // Smooth scroll
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
                
                // Update URL
                history.pushState(null, null, targetId);
                
                // On mobile, close the sidebar after clicking
                if (window.innerWidth < 768) {
                    const sidebar = document.getElementById('sidebar');
                    const main = document.getElementById('main');
                    if (sidebar && sidebar.classList.contains('active')) {
                        sidebar.classList.remove('active');
                        if (main) main.classList.remove('sidebar-active');
                    }
                }
            }
        });
    });
}

// Helper function to find parent heading ID
function getParentHeadingId(heading, targetLevel) {
    let current = heading.previousElementSibling;
    while (current) {
        if (current.tagName.charAt(0) === 'H' && parseInt(current.tagName.charAt(1)) === targetLevel) {
            return current.id;
        }
        current = current.previousElementSibling;
    }
    return null;
}

// Helper function to activate TOC item without tocbot
function activateTOCItem(headings, tocElement) {
    const scrollPos = window.scrollY + 100; // Add offset
    
    // Find the current heading
    let currentHeading = null;
    for (let i = 0; i < headings.length; i++) {
        if (headings[i].offsetTop > scrollPos) {
            currentHeading = i > 0 ? headings[i - 1] : headings[0];
            break;
        }
        if (i === headings.length - 1) {
            currentHeading = headings[i];
        }
    }
    
    if (currentHeading) {
        // Remove active class from all links
        tocElement.querySelectorAll('a').forEach(a => {
            a.classList.remove('is-active-link');
        });
        
        // Add active class to current link
        const activeLink = tocElement.querySelector(`a[href="#${currentHeading.id}"]`);
        if (activeLink) {
            activeLink.classList.add('is-active-link');
            
            // Add active class to parent items
            let parent = activeLink.parentElement;
            while (parent && parent.classList.contains('toc-list-item')) {
                parent.classList.add('is-active-li');
                parent = parent.parentElement?.parentElement; // Skip the ul
            }
        }
    }
}

// Code block enhancements
function enhanceCodeBlocks() {
    const codeBlocks = document.querySelectorAll('pre');
    
    codeBlocks.forEach(block => {
        // Add copy button
        if (!block.querySelector('.copy-btn')) {
            const copyBtn = document.createElement('button');
            copyBtn.className = 'copy-btn';
            copyBtn.innerHTML = '<i class="fas fa-copy"></i>';
            block.appendChild(copyBtn);
            
            copyBtn.addEventListener('click', function() {
                const code = block.querySelector('code')?.textContent || block.textContent;
                navigator.clipboard.writeText(code).then(() => {
                    copyBtn.innerHTML = '<i class="fas fa-check"></i>';
                    setTimeout(() => {
                        copyBtn.innerHTML = '<i class="fas fa-copy"></i>';
                    }, 2000);
                });
            });
        }
        
        // Add language indicator
        const codeElement = block.querySelector('code');
        if (codeElement && codeElement.className) {
            const language = codeElement.className.split('-')[1] || 'code';
            block.setAttribute('data-language', language);
        }
    });
}

// Handle TOC visibility in mobile view
function initializeResponsiveTOC() {
    const tocToggle = document.querySelector('.toc-toggle');
    const tocBody = document.querySelector('.toc-body');
    
    if (tocToggle && tocBody) {
        tocToggle.addEventListener('click', () => {
            tocBody.classList.toggle('d-none');
            tocBody.classList.toggle('d-block');
        });
        
        // Hide sidebar TOC content by default on small screens
        if (window.innerWidth < 768) {
            tocBody.classList.add('d-none');
        }
    }
    
    // Handle resize
    window.addEventListener('resize', debounce(() => {
        if (window.innerWidth >= 992) {
            if (tocBody) {
                tocBody.classList.remove('d-none');
                tocBody.classList.add('d-block');
            }
        }
    }, 200));
}

// Make tables responsive
function makeTablesResponsive() {
    document.addEventListener('DOMContentLoaded', () => {
        const contentArea = document.getElementById('content');
        if (contentArea) {
            // After content is loaded, wrap all tables
            const observer = new MutationObserver(() => {
                const tables = contentArea.querySelectorAll('table');
                tables.forEach(table => {
                    if (!table.parentElement.classList.contains('table-responsive')) {
                        const wrapper = document.createElement('div');
                        wrapper.className = 'table-responsive';
                        table.parentNode.insertBefore(wrapper, table);
                        wrapper.appendChild(table);
                    }
                });
            });
            
            observer.observe(contentArea, { 
                childList: true,
                subtree: true 
            });
        }
    });
}

// Improved mobile sidebar behavior
function initializeMobileSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main');
    
    if (sidebar && mainContent) {
        // Apply mobile styles on load
        if (window.innerWidth < 768) {
            mainContent.style.marginLeft = '0';
            mainContent.style.width = '100%';
        }
        
        // Handle resize
        window.addEventListener('resize', debounce(() => {
            if (window.innerWidth < 768) {
                mainContent.style.marginLeft = '0';
                mainContent.style.width = '100%';
                sidebar.classList.remove('active');
            } else {
                mainContent.style.marginLeft = '';
                mainContent.style.width = '';
            }
        }, 200));
    }
}

// Enhanced Loading Handling
window.addEventListener('load', () => {
    document.body.classList.remove('loading');
    if (document.querySelector('.loading-overlay')) {
        document.querySelector('.loading-overlay').style.opacity = '0';
        setTimeout(() => {
            document.querySelector('.loading-overlay').style.display = 'none';
        }, 300);
    }
});

// Make all content headings scroll-margin aware
function enhanceHeadingScrolling() {
    // Add proper scroll margin to all headings for better anchor link behavior
    document.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(heading => {
        heading.style.scrollMarginTop = '80px'; // Add enough margin for fixed header
    });
    
    // Fix any links that might be within the document
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            const target = document.querySelector(targetId);
            
            if (target) {
                e.preventDefault();
                
                let offset = 80;
                const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - offset;
                
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
                
                // Update URL without scrolling
                history.pushState(null, null, targetId);
            }
        });
    });
}

// Add this function to the initializeAll function
function improveScrollBehavior() {
    // Force vertical scrolling only on the entire document
    document.addEventListener('wheel', function(event) {
        // Prevent all horizontal scrolling from mouse wheel
        if (event.deltaX !== 0) {
            event.preventDefault();
            
            // On some browsers/systems, deltaX scrolling might be intended as vertical scrolling
            // So if deltaY is 0 but deltaX is not, use deltaX for vertical scrolling
            if (event.deltaY === 0 && Math.abs(event.deltaX) > 0) {
                window.scrollBy(0, event.deltaX);
            }
        }
    }, { passive: false });
    
    // Override all scrollable elements to behave properly
    document.querySelectorAll('.table-responsive, pre, code, [style*="overflow"], [style*="overflow-x"]').forEach(element => {
        element.addEventListener('wheel', function(event) {
            // Allow horizontal scrolling only with Shift key held down
            if (!event.shiftKey) {
                // Prevent default to avoid horizontal movement
                event.preventDefault();
                
                // Allow vertical scrolling to continue
                const parentElement = this.closest('.documentation-content') || document.documentElement;
                parentElement.scrollTop += event.deltaY;
            }
        }, { passive: false });
    });
    
    // Apply CSS fixes for horizontal scrolling
    document.documentElement.style.overflowX = 'hidden';
    document.body.style.overflowX = 'hidden';
    
    // Add a mutation observer to handle dynamically added content
    const scrollObserver = new MutationObserver(mutations => {
        mutations.forEach(mutation => {
            if (mutation.addedNodes.length) {
                // Apply scroll handling to any new scrollable elements
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1) { // Element node
                        const scrollables = node.querySelectorAll?.('.table-responsive, pre, code, [style*="overflow"], [style*="overflow-x"]');
                        if (scrollables) {
                            scrollables.forEach(element => {
                                element.addEventListener('wheel', function(event) {
                                    if (!event.shiftKey) {
                                        event.preventDefault();
                                        const parentElement = this.closest('.documentation-content') || document.documentElement;
                                        parentElement.scrollTop += event.deltaY;
                                    }
                                }, { passive: false });
                            });
                        }
                    }
                });
            }
        });
    });
    
    scrollObserver.observe(document.body, {
        childList: true,
        subtree: true
    });
}

// Enhanced event handling for responsive scroll behavior
window.addEventListener('load', function() {
    // Fix any initial scroll issues
    document.body.style.overflowX = 'hidden';
    document.documentElement.style.overflowX = 'hidden';
    
    // Additional fixes for mobile devices
    if ('ontouchstart' in window) {
        document.documentElement.style.overscrollBehaviorY = 'contain';
    }
});

// Enhanced responsive initialization
function enhanceResponsiveness() {
    // Better handling of orientation changes
    window.addEventListener('orientationchange', () => {
        // Add a small delay to let the browser finish the orientation change
        setTimeout(() => {
            // Adjust layout after orientation change
            adjustLayout();
            
            // Recalculate TOC and scroll positions
            if (typeof tocbot !== 'undefined' && tocbot.refresh) {
                tocbot.refresh();
            }
            
            // Force recalculation of progress bar
            const progressBar = document.querySelector('.reading-progress');
            if (progressBar) {
                const docElement = document.documentElement;
                const totalHeight = docElement.scrollHeight - docElement.clientHeight;
                const progress = (window.scrollY / totalHeight) * 100;
                progressBar.style.width = `${progress}%`;
            }
        }, 300);
    });
    
    // Initial layout adjustment
    adjustLayout();
    
    // Handle viewport height changes for mobile browsers (address bar appearing/disappearing)
    let lastVH = window.innerHeight;
    window.addEventListener('resize', debounce(() => {
        if (Math.abs(lastVH - window.innerHeight) > 100) {
            // Viewport height changed significantly, adjust layout
            lastVH = window.innerHeight;
            adjustLayout();
        }
    }, 100));
}

// Layout adjustment based on device
function adjustLayout() {
    const isMobile = window.innerWidth < 768;
    const isTablet = window.innerWidth >= 768 && window.innerWidth < 992;
    
    // Document body
    document.body.classList.toggle('is-mobile', isMobile);
    document.body.classList.toggle('is-tablet', isTablet);
    
    // Adjust content padding
    if (isMobile) {
        document.documentElement.style.setProperty('--content-padding', '1rem');
    } else if (isTablet) {
        document.documentElement.style.setProperty('--content-padding', '1.5rem');
    } else {
        document.documentElement.style.setProperty('--content-padding', '2rem');
    }
}
