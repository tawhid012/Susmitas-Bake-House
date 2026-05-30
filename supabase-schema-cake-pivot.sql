-- 1. DELETE existing non-cake categories (and their associated products via CASCADE if setup, or manually)
-- If foreign keys do not cascade, we must delete products first.
DELETE FROM products 
WHERE category_id IN (
  SELECT id FROM categories WHERE slug IN ('personalised-gifts', 'keychains', 'bouquets')
);

DELETE FROM categories 
WHERE slug IN ('personalised-gifts', 'keychains', 'bouquets');

-- 2. INSERT new Cake Categories
INSERT INTO categories (name, slug, description, active)
VALUES
  ('Birthday Specials', 'birthday-cakes', 'Delicious and fun cakes perfect for birthday celebrations.', true),
  ('Anniversary Specials', 'anniversary-cakes', 'Romantic and elegant cakes for your special day.', true),
  ('Wedding Cakes', 'wedding-cakes', 'Multi-tier premium cakes for weddings.', true),
  ('Bento Cakes', 'bento-cakes', 'Cute, single-portion cakes in a box.', true)
ON CONFLICT (slug) DO NOTHING;

-- 3. (Optional) Insert some dummy products for testing if needed
-- INSERT INTO products (name, slug, description, short_description, base_price, category_id, bestseller)
-- VALUES ('Chocolate Truffle Bento', 'truffle-bento', '...', 'Mini truffle cake', 350, (SELECT id FROM categories WHERE slug='bento-cakes'), true);
