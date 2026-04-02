function addVariantRow() {
    var container = document.getElementById('variantsContainer');
    var firstRow = container.querySelector('.variant-row');
    var newRow = firstRow.cloneNode(true);

    /* Clear all text/number inputs */
    newRow.querySelectorAll('input[type="text"], input[type="number"]').forEach(function(input) {
        input.value = '';
    });

    /* Clear the hidden variantId so the servlet treats this as a NEW variant, not an update */
    var hiddenId = newRow.querySelector('input[type="hidden"][name="variantId[]"]');
    if (hiddenId) hiddenId.value = '';

    /* Replace file input with a fresh one (file inputs cannot be cleared by value) */
    var oldFileInput = newRow.querySelector('input[type="file"].variant-image-input');
    if (oldFileInput) {
        var freshFile = document.createElement('input');
        freshFile.type = 'file';
        freshFile.name = 'variantImage[]';
        freshFile.accept = 'image/*';
        freshFile.className = 'variant-image-input';
        oldFileInput.parentNode.replaceChild(freshFile, oldFileInput);
    }

    /* Hide stale image preview */
    var preview = newRow.querySelector('.variant-image-preview');
    if (preview) { preview.src = ''; preview.style.display = 'none'; }

    /* Hide any current-image thumbnail (only relevant in edit form) */
    var currentThumb = newRow.querySelector('.variant-current-image');
    if (currentThumb) currentThumb.style.display = 'none';

    container.appendChild(newRow);

    /* Apply current category labels if category JS is loaded */
    if (typeof applyCategoryLabelsToRow === 'function') {
        applyCategoryLabelsToRow(newRow);
    }
}

function removeVariantRow(btn) {
    var row = btn.closest('.variant-row');
    if (document.querySelectorAll('.variant-row').length > 1) {
        row.remove();
    } else {
        alert('At least one variant row is required. Clear the fields if you don\'t want variants.');
    }
    checkVariantFields();
}

function checkVariantFields() {
    var variantRows = document.querySelectorAll('.variant-row');
    var hasVariants = false;

    variantRows.forEach(function(row) {
        var color = row.querySelector('input[name="variantColor[]"]');
        var size = row.querySelector('input[name="variantSize[]"]');
        var power = row.querySelector('input[name="variantPower[]"]');
        var price = row.querySelector('input[name="variantPrice[]"]');
        var qty = row.querySelector('input[name="variantQuantity[]"]');

        if ((color && color.value.trim()) || (size && size.value.trim()) ||
            (power && power.value.trim()) || (price && price.value.trim()) ||
            (qty && qty.value.trim())) {
            hasVariants = true;
        }
    });

    var quantityInput = document.getElementById('quantityInput');
    var quantityNote = document.getElementById('quantityNote');
    var priceInput = document.getElementsByName('price')[0];
    var priceNote = document.getElementById('priceNote');

    if (hasVariants) {
        if (quantityInput) {
            quantityInput.removeAttribute('required');
            quantityInput.value = '0';
        }
        if (quantityNote) {
            quantityNote.textContent = '(Not required - variants have their own quantities)';
            quantityNote.classList.add('success');
        }
        if (priceInput) priceInput.removeAttribute('required');
        if (priceNote) {
            priceNote.textContent = '(Optional if variants have prices)';
            priceNote.classList.add('success');
        }
    } else {
        if (quantityInput) quantityInput.setAttribute('required', 'required');
        if (quantityNote) {
            quantityNote.textContent = '(Required if no variants)';
            quantityNote.classList.remove('success');
        }
        if (priceInput) priceInput.setAttribute('required', 'required');
        if (priceNote) {
            priceNote.textContent = '';
            priceNote.classList.remove('success');
        }
    }
}

/* Validate that every non-empty variant row has both price and quantity filled.
   Returns true if valid (allows form submit), false if invalid (blocks submit). */
function validateVariantsOnSubmit() {
    var rows = document.querySelectorAll('.variant-row');
    var errors = [];

    rows.forEach(function(row, idx) {
        var color = row.querySelector('input[name="variantColor[]"]');
        var size  = row.querySelector('input[name="variantSize[]"]');
        var power = row.querySelector('input[name="variantPower[]"]');
        var price = row.querySelector('input[name="variantPrice[]"]');
        var qty   = row.querySelector('input[name="variantQuantity[]"]');

        var hasAttribute = (color && color.value.trim()) ||
                           (size  && size.value.trim())  ||
                           (power && power.value.trim());

        if (!hasAttribute) return; // blank row — skip

        var missingPrice = !price || !price.value.trim();
        var missingQty   = !qty   || !qty.value.trim();

        if (missingPrice || missingQty) {
            var label = 'Variant ' + (idx + 1);
            var missing = [];
            if (missingPrice) { missing.push('price'); if (price) price.style.outline = '2px solid red'; }
            if (missingQty)   { missing.push('quantity'); if (qty) qty.style.outline = '2px solid red'; }
            errors.push(label + ': missing ' + missing.join(' and '));
        } else {
            // Clear any previous error highlights
            if (price) price.style.outline = '';
            if (qty)   qty.style.outline   = '';
        }
    });

    if (errors.length > 0) {
        alert('Please fill in the following before saving:\n\n' + errors.join('\n'));
        return false;
    }
    return true;
}

document.addEventListener('DOMContentLoaded', function() {
    checkVariantFields();

    var variantContainer = document.getElementById('variantsContainer');
    if (variantContainer) {
        variantContainer.addEventListener('input', function(e) {
            if (e.target.name && e.target.name.indexOf('variant') !== -1) {
                checkVariantFields();
                // Clear red outline when user starts typing
                if (e.target.style && e.target.style.outline) e.target.style.outline = '';
            }
        });

        // Attach submit safeguard to the parent form
        var form = variantContainer.closest('form');
        if (form) {
            form.addEventListener('submit', function(e) {
                if (!validateVariantsOnSubmit()) {
                    e.preventDefault();
                }
            });
        }
    }
});
