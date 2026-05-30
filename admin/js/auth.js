// admin/js/auth.js

// Make sure Supabase is loaded first
async function checkAuth() {
    const { data: { session } } = await supabaseClient.auth.getSession();
    
    // If not logged in and not on login page, redirect
    if (!session && !window.location.pathname.includes('login.html')) {
        window.location.href = 'login.html';
    }
    
    // If logged in and on login page, redirect to dashboard
    if (session && window.location.pathname.includes('login.html')) {
        window.location.href = 'index.html';
    }

    return session;
}

async function login(email, password) {
    const { data, error } = await supabaseClient.auth.signInWithPassword({
        email: email,
        password: password,
    });

    if (error) {
        alert(error.message);
    } else {
        window.location.href = 'index.html';
    }
}

async function logout() {
    await supabaseClient.auth.signOut();
    window.location.href = 'login.html';
}

// Check auth on page load (unless on login page)
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();
});
