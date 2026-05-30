// js/supabase-config.js
// Configuration for Supabase Backend

const SUPABASE_URL = 'https://eyqmysjjreejdsssgnyk.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV5cW15c2pqcmVlamRzc3NnbnlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAwOTIxNTYsImV4cCI6MjA5NTY2ODE1Nn0.t72MHnScSKGp7nEs5pmgQrZme6U8IGXhXiDp1wG8MBM';

// Initialize the Supabase client
const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
