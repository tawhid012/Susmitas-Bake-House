// js/cart.js
// Basic Cart State Management using localStorage

class Cart {
    constructor() {
        this.items = JSON.parse(localStorage.getItem('bakery_cart')) || [];
        this.updateCartBadge();
    }

    save() {
        localStorage.setItem('bakery_cart', JSON.stringify(this.items));
        this.updateCartBadge();
    }

    addItem(item) {
        // item expected to be { id, name, price, quantity, options: { weight, flavor, message, type (standard/custom) } }
        const existingItem = this.items.find(i => 
            i.id === item.id && 
            JSON.stringify(i.options) === JSON.stringify(item.options)
        );

        if (existingItem) {
            existingItem.quantity += parseInt(item.quantity);
        } else {
            this.items.push(item);
        }
        this.save();
        this.showToast('✓ Added to cart');
    }

    showToast(message) {
        const toast = document.createElement('div');
        toast.textContent = message;
        toast.style.position = 'fixed';
        toast.style.bottom = '90px'; // Above the bottom nav
        toast.style.left = '50%';
        toast.style.transform = 'translateX(-50%)';
        toast.style.backgroundColor = '#267E3E'; // Premium green
        toast.style.color = 'white';
        toast.style.padding = '12px 24px';
        toast.style.borderRadius = '30px';
        toast.style.boxShadow = '0 4px 16px rgba(38, 126, 62, 0.3)';
        toast.style.zIndex = '9999';
        toast.style.fontWeight = '600';
        toast.style.fontSize = '14px';
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
        
        document.body.appendChild(toast);
        
        setTimeout(() => {
            toast.style.opacity = '1';
            toast.style.transform = 'translate(-50%, -10px)';
        }, 10);
        
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translate(-50%, 10px)';
            setTimeout(() => toast.remove(), 300);
        }, 2000);
    }

    removeItem(index) {
        this.items.splice(index, 1);
        this.save();
    }

    updateQuantity(index, newQuantity) {
        if (newQuantity <= 0) {
            this.removeItem(index);
        } else {
            this.items[index].quantity = parseInt(newQuantity);
            this.save();
        }
    }

    getTotal() {
        return this.items.reduce((total, item) => total + (item.price * item.quantity), 0);
    }

    clear() {
        this.items = [];
        this.save();
    }

    updateCartBadge() {
        const totalItems = this.items.reduce((sum, item) => sum + item.quantity, 0);
        const badges = document.querySelectorAll('.cart-badge');
        badges.forEach(badge => {
            badge.textContent = totalItems;
            badge.style.display = totalItems > 0 ? 'inline-flex' : 'none';
        });
    }
}

// Initialize global cart
const bakeryCart = new Cart();
