import { useEffect, useState } from 'react';
import { motion } from 'motion/react';
import { Product } from '../types';
import ProductCard from '../components/ProductCard';
import { LayoutGrid, List } from 'lucide-react';

const CATEGORIES = [
  "electronics",
  "jewelery",
  "men's clothing",
  "women's clothing"
];

export default function Home() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);

  useEffect(() => {
    fetch('https://dummyjson.com/products')
      .then(res => res.json())
      .then(data => {
        // Mapping dummyjson to the structure we want (simplified)
        const mapped = data.products.map((p: any) => ({
          id: p.id,
          title: p.title,
          price: p.price,
          description: p.description,
          category: p.category,
          image: p.thumbnail,
          rating: { rate: p.rating, count: 100 }
        }));
        setProducts(mapped);
        setLoading(false);
      });
  }, []);

  const filteredProducts = selectedCategory 
    ? products.filter(p => p.category === selectedCategory)
    : products;

  const categories = Array.from(new Set(products.map(p => p.category)));

  return (
    <div className="space-y-12">
      <section className="relative h-[400px] rounded-3xl overflow-hidden bg-gradient-to-br from-blue-900 to-black flex items-center px-12">
        <div className="relative z-10 max-w-xl space-y-6">
          <motion.h1 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-6xl font-bold leading-tight"
          >
            Elevate Your <span className="text-blue-500 italic">Lifestyle</span>.
          </motion.h1>
          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="text-gray-400 text-lg"
          >
            Curated collection of professional-grade products designed for those who demand excellence in every detail.
          </motion.p>
        </div>
        <div className="absolute top-0 right-0 w-1/2 h-full opacity-30 select-none pointer-events-none">
          <div className="absolute inset-0 bg-gradient-to-l from-[#0F0F1E] to-transparent z-10" />
          <div className="grid grid-cols-4 gap-4 p-8 items-start">
             {/* Decorative grid */}
             {Array.from({ length: 16 }).map((_, i) => (
               <div key={i} className="aspect-square border border-white/5 bg-white/5 rounded-lg" />
             ))}
          </div>
        </div>
      </section>

      <section className="space-y-8">
        <div className="flex items-center justify-between border-b border-white/10 pb-6">
          <div className="space-y-1">
            <h2 className="text-2xl font-semibold tracking-tight uppercase italic serif font-serif">Categories</h2>
            <p className="text-xs text-gray-500 font-mono">FILTER BY SECTION_ID</p>
          </div>
          <div className="flex gap-2">
            <button 
              onClick={() => setSelectedCategory(null)}
              className={`px-4 py-1.5 rounded-full text-xs font-mono transition-all ${!selectedCategory ? 'bg-blue-600 text-white' : 'bg-white/5 text-gray-400 hover:bg-white/10'}`}
            >
              ALL_ITEMS
            </button>
            {categories.map(cat => (
              <button 
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`px-4 py-1.5 rounded-full text-xs font-mono transition-all ${selectedCategory === cat ? 'bg-blue-600 text-white' : 'bg-white/5 text-gray-400 hover:bg-white/10'}`}
              >
                {cat.toUpperCase().replace('-', '_')}
              </button>
            ))}
          </div>
        </div>

        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {Array.from({ length: 8 }).map((_, i) => (
              <div key={i} className="aspect-[3/4] bg-white/5 animate-pulse rounded-2xl" />
            ))}
          </div>
        ) : (
          <motion.div 
            layout
            className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-6 gap-y-10"
          >
            {filteredProducts.map(product => (
              <ProductCard key={product.id} product={product} />
            ))}
          </motion.div>
        )}
      </section>
    </div>
  );
}
