import { useState, useEffect } from 'react';
import { Product, CartItem } from '../types';
import { Trash2, Plus, Minus, ShoppingBag, ArrowRight } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

export default function Cart() {
  const [cart, setCart] = useState<CartItem[]>([]);

  useEffect(() => {
    const saved = localStorage.getItem('cart');
    if (saved) setCart(JSON.parse(saved));
  }, []);

  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const updateQuantity = (id: number, delta: number) => {
    const newCart = cart.map(item => {
      if (item.id === id) {
        return { ...item, quantity: Math.max(1, item.quantity + delta) };
      }
      return item;
    });
    setCart(newCart);
    localStorage.setItem('cart', JSON.stringify(newCart));
  };

  const removeItem = (id: number) => {
    const newCart = cart.filter(item => item.id !== id);
    setCart(newCart);
    localStorage.setItem('cart', JSON.stringify(newCart));
  };

  return (
    <div className="space-y-10">
      <div className="border-b border-white/10 pb-6">
        <h1 className="text-4xl font-bold tracking-tight">Shopping <span className="text-blue-500">Cart</span></h1>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
        <div className="lg:col-span-2 space-y-6">
          <AnimatePresence mode="popLayout">
            {cart.length > 0 ? (
              cart.map(item => (
                <motion.div 
                  key={item.id}
                  layout
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: 20 }}
                  className="flex items-center gap-6 p-4 bg-[#1E1E2C]/40 border border-white/5 rounded-2xl group"
                >
                  <div className="w-24 h-24 bg-white/5 rounded-xl overflow-hidden p-2">
                    <img src={item.image} alt="" className="w-full h-full object-contain mix-blend-lighten" />
                  </div>
                  <div className="flex-grow space-y-1">
                    <span className="text-[10px] font-mono text-blue-400 uppercase">{item.category}</span>
                    <h3 className="font-medium">{item.title}</h3>
                    <div className="flex items-center gap-4 pt-2">
                      <div className="flex items-center bg-black/20 rounded-lg p-1 border border-white/5">
                        <button onClick={() => updateQuantity(item.id, -1)} className="p-1 hover:text-white text-gray-400">
                          <Minus className="w-4 h-4" />
                        </button>
                        <span className="w-8 text-center text-sm font-mono">{item.quantity}</span>
                        <button onClick={() => updateQuantity(item.id, 1)} className="p-1 hover:text-white text-gray-400">
                          <Plus className="w-4 h-4" />
                        </button>
                      </div>
                      <button onClick={() => removeItem(item.id)} className="text-gray-500 hover:text-red-500 transition-colors">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                  <div className="text-right flex flex-col justify-center gap-1">
                     <span className="text-xs text-gray-500 font-mono">UNIT_PRICE</span>
                     <span className="text-lg font-bold">${(item.price * item.quantity).toFixed(2)}</span>
                  </div>
                </motion.div>
              ))
            ) : (
              <div className="flex flex-col items-center justify-center py-24 text-center space-y-6">
                <div className="bg-white/5 p-8 rounded-full">
                  <ShoppingBag className="w-16 h-16 text-gray-700" />
                </div>
                <div className="space-y-2">
                  <h3 className="text-2xl font-semibold">Your cart is empty</h3>
                  <p className="text-gray-500">Looks like you haven't added anything to your cart yet.</p>
                </div>
                <button 
                  onClick={() => window.location.href = '/'}
                  className="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-full font-semibold transition-all"
                >
                  START_SHOPPING
                </button>
              </div>
            )}
          </AnimatePresence>
        </div>

        <div className="space-y-6">
          <div className="bg-[#1E1E2C] border border-white/10 rounded-3xl p-8 space-y-6 sticky top-24">
            <h2 className="text-xl font-semibold tracking-tight uppercase font-serif italic border-b border-white/5 pb-4">Order Summary</h2>
            
            <div className="space-y-3">
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Subtotal</span>
                <span className="font-mono">${total.toFixed(2)}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Tax (8%)</span>
                <span className="font-mono">${(total * 0.08).toFixed(2)}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-400">Shipping</span>
                <span className="text-green-500 uppercase font-mono text-[10px] bg-green-500/10 px-2 py-0.5 rounded">Free</span>
              </div>
            </div>

            <div className="pt-4 border-t border-white/5 flex justify-between items-end">
              <div className="flex flex-col">
                <span className="text-[10px] font-mono text-gray-500">ESTIMATED_TOTAL</span>
                <span className="text-3xl font-bold tracking-tighter text-blue-500">${(total * 1.08).toFixed(2)}</span>
              </div>
            </div>

            <button 
              disabled={cart.length === 0}
              className="w-full bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed text-white py-4 rounded-2xl font-bold transition-all flex items-center justify-center gap-2 group"
            >
              PROCEED_TO_CHECKOUT
              <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
            </button>
            
            <div className="flex items-center justify-center gap-4 text-gray-600 pt-2">
               <div className="w-8 h-5 bg-white/5 rounded border border-white/5" />
               <div className="w-8 h-5 bg-white/5 rounded border border-white/5" />
               <div className="w-8 h-5 bg-white/5 rounded border border-white/5" />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
