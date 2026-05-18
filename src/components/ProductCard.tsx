import { Product } from '../types';
import { motion } from 'motion/react';
import { Heart, ShoppingBag, Star } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function ProductCard({ product }: { product: Product }) {
  const navigate = useNavigate();

  return (
    <motion.div 
      layout
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      className="group relative flex flex-col h-full bg-[#1E1E2C]/40 border border-white/5 rounded-2xl overflow-hidden hover:border-blue-500/30 transition-colors"
    >
      <div className="relative aspect-square overflow-hidden bg-white/5 p-4">
        <img 
          src={product.image} 
          alt={product.title}
          className="w-full h-full object-contain mix-blend-lighten group-hover:scale-110 transition-transform duration-500"
        />
        <div className="absolute top-3 right-3 flex flex-col gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
          <button className="bg-white/10 backdrop-blur-md p-2 rounded-full hover:bg-red-500/20 hover:text-red-500 transition-colors">
            <Heart className="w-4 h-4" />
          </button>
          <button className="bg-white/10 backdrop-blur-md p-2 rounded-full hover:bg-blue-500/20 hover:text-blue-500 transition-colors">
            <ShoppingBag className="w-4 h-4" />
          </button>
        </div>
      </div>

      <div className="p-5 flex flex-col flex-grow space-y-4">
        <div className="space-y-1">
          <div className="flex items-center justify-between">
            <span className="text-[10px] font-mono tracking-widest text-blue-400 uppercase">{product.category}</span>
            <div className="flex items-center gap-1">
              <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
              <span className="text-xs text-gray-400">{product.rating?.rate}</span>
            </div>
          </div>
          <h3 className="text-sm font-medium leading-tight group-hover:text-blue-400 transition-colors line-clamp-2">
            {product.title}
          </h3>
        </div>

        <div className="mt-auto pt-4 flex items-center justify-between border-t border-white/5">
          <div className="flex flex-col">
            <span className="text-xs text-gray-500 font-mono">USD</span>
            <span className="text-xl font-bold tracking-tight">${product.price}</span>
          </div>
          <button 
            onClick={() => navigate(`/product/${product.id}`)}
            className="text-xs font-mono text-gray-400 hover:text-white underline underline-offset-4"
          >
            VIEW_DETAILS
          </button>
        </div>
      </div>
    </motion.div>
  );
}
