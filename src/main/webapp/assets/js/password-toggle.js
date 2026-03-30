// Password Toggle Functionality
(function() {
    'use strict';

    // Initialize password toggles for all password inputs
    function initPasswordToggles() {
        // Find all password input fields
        const passwordInputs = document.querySelectorAll('input[type="password"]');
        
        passwordInputs.forEach(input => {
            // Skip if already has a toggle button
            if (input.parentElement.querySelector('.password-toggle-btn')) {
                return;
            }

            // Get the parent container (form-group, input-field, or password-input-wrapper)
            let container = input.parentElement;
            
            // If parent is not a container, use it directly and make it relative
            if (!container.classList.contains('form-group') && 
                !container.classList.contains('input-field') && 
                !container.classList.contains('password-input-wrapper')) {
                // Check if we should wrap it
                if (container.tagName === 'DIV' || container.classList.contains('form-group') || container.classList.contains('input-field')) {
                    // Already in a suitable container
                } else {
                    // Create wrapper
                    const wrapper = document.createElement('div');
                    wrapper.className = 'password-input-wrapper';
                    input.parentNode.insertBefore(wrapper, input);
                    wrapper.appendChild(input);
                    container = wrapper;
                }
            }

            // Make container position relative if not already
            const computedStyle = window.getComputedStyle(container);
            if (computedStyle.position === 'static') {
                container.style.position = 'relative';
            }

            // Create toggle button
            const toggleBtn = document.createElement('button');
            toggleBtn.type = 'button';
            toggleBtn.className = 'password-toggle-btn';
            toggleBtn.setAttribute('aria-label', 'Show password');
            toggleBtn.innerHTML = 'Show';
            toggleBtn.setAttribute('tabindex', '0');
            
            // Insert button into container (after input)
            container.appendChild(toggleBtn);

            // Ensure input has padding-right for the button
            if (!input.style.paddingRight || input.style.paddingRight === '') {
                input.style.paddingRight = '3rem';
            }

            // Toggle functionality
            toggleBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                toggleBtn.innerHTML = isPassword ? 'Hide' : 'Show';
                toggleBtn.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
            });
        });
    }

    // Initialize on DOM load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initPasswordToggles);
    } else {
        initPasswordToggles();
    }
})();
