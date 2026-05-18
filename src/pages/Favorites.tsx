import { useEffect, useState } from 'react';
import { db, auth } from '../lib/firebase';
import { collection, onSnapshot, query } from 'firebase/firestore';
import { Product } from '../types';
import ProductCard from '../components/ProductCard';
import { Heart, Ghost } from 'lucide-react';
import { motion } from 'motion/react';

export default function Favorites() {
  const [favorites, setFavorites] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!auth.currentUser) return;

    const favRef = collection(db, 'users', auth.currentUser.uid, 'favorites');
    const q = query(favRef);

    const unsubscribe = onSnapshot(q, async (snapshot) => {
      const favIds = snapshot.docs.map(doc => doc.data().productId);
      
      if (favIds.length === 0) {
        setFavorites([]);
        setLoading(false);
        return;
      }

      // Fetch product details for these IDs from our API
      try {
        const res = await fetch('https://dummyjson.com/products');
        const data = await res.json();
        const allProducts = data.products.map((p: any) => ({
          id: p.id,
          title: p.title,
          price: p.price,
          description: p.description,
          category: p.category,
          image: p.thumbnail,
          rating: { rate: p.rating, count: 100 }
        }));

        setFavorites(allProducts.filter((p: Product) => favIds.includes(p.id)));
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <div className="space-y-10">
      <div className="border-b border-white/10 pb-6 flex items-center justify-between">
        <h1 className="text-4xl font-bold tracking-tight">Your <span className="text-red-500">Favorites</span></h1>
        <div className="flex items-center gap-2 text-xs font-mono text-gray-500 uppercase">
          <Heart className="w-4 h-4" />
          {favorites.length} SAVED_UNITS
        </div>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="aspect-[3/4] bg-white/5 animate-pulse rounded-2xl" />
          ))}
        </div>
      ) : favorites.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-6 gap-y-10">
          {favorites.map(product => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      ) : (
        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="flex flex-col items-center justify-center py-24 space-y-4 text-center"
        >
          <div className="bg-white/5 p-6 rounded-full">
            <Ghost className="w-12 h-12 text-gray-600" />
          </div>
          <div className="space-y-1">
            <h3 className="text-xl font-medium">No favorites yet</h3>
            <p className="text-gray-500 max-w-xs">Start exploring our collection and save items you love to find them easily later.</p>
          </div>
          <button 
            onClick={() => window.location.href = '/'}
            className="text-blue-500 font-medium hover:underline flex items-center gap-2"
          >
            GO_TO_CATALOGUE
          </button>
        </motion.div>
      )}
    </div>
  );
}
