function addVariantRow() {
    var container = document.getElementById('variantsContainer');
    var firstRow = container.querySelector('.variant-row');
    var newRow = firstRow.cloneNode(true);

    newRow.querySelectorAll('input').forEach(function(input) {
        input.value = '';
    });

    container.appendChild(newRow);
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

document.addEventListener('DOMContentLoaded', function() {
    checkVariantFields();

    var variantContainer = document.getElementById('variantsContainer');
    if (variantContainer) {
        variantContainer.addEventListener('input', function(e) {
            if (e.target.name && e.target.name.indexOf('variant') !== -1) {
                checkVariantFields();
            }
        });
    }
});
