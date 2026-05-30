// js/api.js
// API wrapper for Supabase database operations

const API = {
    // Products
    async getProducts(categorySlug = null) {
        try {
            const [prodResult, catResult] = await Promise.all([
                supabaseClient.from('products').select('*').eq('active', true),
                supabaseClient.from('categories').select('*')
            ]);
            
            if (prodResult.error) throw prodResult.error;
            let products = prodResult.data;
            let categories = catResult.data;

            if (!catResult.error && categories) {
                products = products.map(p => {
                    const cat = categories.find(c => c.id === p.category_id);
                    return { ...p, categories: cat ? { name: cat.name, slug: cat.slug } : null };
                });
            }

            return products;
        } catch (err) {
            console.error('Error fetching products:', err);
            return [];
        }
    },

    async getProductBySlug(slug) {
        try {
            const { data, error } = await supabaseClient.from('products').select('*').eq('slug', slug).single();
            if (error) throw error;
            return data;
        } catch (err) {
            console.error('Error fetching product:', err);
            return null;
        }
    },

    async getFeaturedProducts() {
        try {
            const [prodResult, catResult] = await Promise.all([
                supabaseClient.from('products').select('*').eq('active', true).eq('bestseller', true),
                supabaseClient.from('categories').select('*')
            ]);
            
            if (prodResult.error) throw prodResult.error;
            let products = prodResult.data;
            let categories = catResult.data;
            
            if (categories) {
                const excluded = ['personalised-gifts', 'keychains', 'bouquets'];
                const filtered = products.filter(p => {
                    if (!p.category_id) return true; // Keep uncategorized cakes
                    const cat = categories.find(c => c.id === p.category_id);
                    return !cat || !excluded.includes(cat.slug);
                });
                return filtered.slice(0, 5);
            }
            
            return products.slice(0, 5);
        } catch (err) {
            console.error('Error fetching featured products:', err);
            return [];
        }
    },

    async getProductsByCategorySlug(slug) {
        try {
            const { data: catData, error: catError } = await supabaseClient.from('categories').select('id').eq('slug', slug).single();
            if (catError || !catData) return [];
            
            const { data, error } = await supabaseClient.from('products').select('*').eq('active', true).eq('category_id', catData.id);
            if (error) throw error;
            return data;
        } catch (err) {
            console.error('Error fetching products for slug ' + slug + ':', err);
            return [];
        }
    },

    // Optimized Single-Call Fetch for Homepage to prevent slow loading
    async getHomepageProducts() {
        try {
            const [prodResult, catResult] = await Promise.all([
                supabaseClient.from('products').select('*').eq('active', true),
                supabaseClient.from('categories').select('*')
            ]);
            
            if (prodResult.error) throw prodResult.error;
            let products = prodResult.data || [];
            let categories = catResult.data || [];
            
            // Map categories to products for easy filtering
            products.forEach(p => {
                p.category = categories.find(c => c.id === p.category_id) || null;
            });
            
            return {
                featured: products.filter(p => p.bestseller).slice(0, 5),
                birthdays: products.filter(p => p.category && p.category.slug === 'birthday-cakes'),
                anniversaries: products.filter(p => p.category && p.category.slug === 'anniversary-cakes'),
                bento: products.filter(p => p.category && p.category.slug === 'bento-cakes'),
                wedding: products.filter(p => p.category && p.category.slug === 'wedding-cakes')
            };
        } catch (err) {
            console.error('Error fetching homepage products:', err);
            return { featured: [], birthdays: [], anniversaries: [], bento: [], wedding: [] };
        }
    },

    // Categories
    async getCategories() {
        try {
            const { data, error } = await supabaseClient.from('categories').select('*').eq('active', true);
            if (error) throw error;
            return data;
        } catch (err) {
            console.error('Error fetching categories:', err);
            return [];
        }
    },

    // Orders (Public Insert)
    async createOrder(orderData, items) {
        try {
            // Generate a random order number
            const orderNumber = 'SBH-' + Math.floor(100000 + Math.random() * 900000);
            orderData.order_number = orderNumber;

            // Insert Order
            const { data: order, error: orderError } = await supabase
                .from('orders')
                .insert([orderData])
                .select()
                .single();

            if (orderError) throw orderError;

            // Prepare items
            const orderItems = items.map(item => ({
                order_id: order.id,
                product_name: item.name,
                quantity: item.quantity,
                flavor: item.options.flavor || item.options.diet || '',
                weight: item.options.weight || '',
                cake_message: item.options.message || '',
                price: item.price,
                type: item.options.type || 'standard'
            }));

            // Insert Items
            const { error: itemsError } = await supabase
                .from('order_items')
                .insert(orderItems);

            if (itemsError) throw itemsError;

            return orderNumber;
        } catch (err) {
            console.error('Error creating order:', err);
            return null;
        }
    },

    // Homepage CMS
    async getHomepageSections() {
        try {
            const { data, error } = await supabaseClient.from('homepage_sections').select('*').eq('active', true);
            if (error) throw error;
            
            // Format into an easily accessible object
            const sections = {};
            if(data) {
                data.forEach(s => sections[s.section_key] = s.content);
            }
            return sections;
        } catch (err) {
            console.error('Error fetching homepage CMS:', err);
            return {};
        }
    }
};
