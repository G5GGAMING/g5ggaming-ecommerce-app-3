import { useParams, Link } from 'react-router-dom';
import { useEffect, useState } from 'react';
import { Product } from '../types';
import ProductCard from '../components/ProductCard';
import { ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

export default function CategoryProducts() {
  const { id } = useParams();
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('https://dummyjson.com/products')
      .then(res => res.json())
      .then(data => {
        const mapped = data.products.map((p: any) => ({
          id: p.id,
          title: p.title,
          price: p.price,
          description: p.description,
          category: p.category,
          image: p.thumbnail,
          rating: { rate: p.rating, count: 100 }
        }));
        setProducts(mapped.filter((p: Product) => p.category === id));
        setLoading(false);
      });
  }, [id]);

  return (
    <div className="space-y-10">
      <nav className="flex items-center gap-2 text-xs font-mono text-gray-500 uppercase">
        <Link to="/" className="hover:text-blue-500">Shop</Link>
        <ChevronRight className="w-3 h-3" />
        <span className="text-white">{id?.replace('-', '_')}</span>
      </nav>

      <div className="border-b border-white/10 pb-6">
        <h1 className="text-4xl font-bold tracking-tight uppercase">
          {id?.replace('-', ' ')}
        </h1>
      </div>

      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {Array.from({ length: 4 }).map((_, i) => (
            <div key={i} className="aspect-[3/4] bg-white/5 animate-pulse rounded-2xl" />
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-6 gap-y-10">
          {products.map(product => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      )}
    </div>
  );
}
