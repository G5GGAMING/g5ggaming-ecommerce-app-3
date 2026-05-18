import { Link, useNavigate } from 'react-router-dom';
import { User, signOut } from 'firebase/auth';
import { auth } from '../lib/firebase';
import { ShoppingCart, Heart, User as UserIcon, LogOut, Package } from 'lucide-react';
import { motion } from 'motion/react';

export default function Navbar({ user }: { user: User | null }) {
  const navigate = useNavigate();

  const handleLogout = async () => {
    await signOut(auth);
    navigate('/login');
  };

  return (
    <nav className="sticky top-0 z-50 bg-[#1E1E2C]/80 backdrop-blur-md border-b border-white/10 px-4 py-4">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        <Link to="/" className="flex items-center gap-2 group">
          <div className="bg-blue-600 p-2 rounded-lg group-hover:scale-110 transition-transform">
            <Package className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-bold tracking-tight">E-PRO</span>
        </Link>

        <div className="flex items-center gap-6">
          <Link to="/" className="text-gray-300 hover:text-white transition-colors">Shop</Link>
          <Link to="/favorites" className="relative group">
            <Heart className="w-6 h-6 text-gray-300 group-hover:text-red-500 transition-colors" />
          </Link>
          <Link to="/cart" className="relative group">
            <ShoppingCart className="w-6 h-6 text-gray-300 group-hover:text-blue-500 transition-colors" />
          </Link>

          {user ? (
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 bg-white/5 px-3 py-1.5 rounded-full border border-white/10">
                {user.photoURL ? (
                  <img src={user.photoURL} alt="" className="w-6 h-6 rounded-full" />
                ) : (
                  <UserIcon className="w-4 h-4 text-gray-400" />
                )}
                <span className="text-sm font-medium text-gray-300 truncate max-w-[100px]">
                  {user.displayName || user.email}
                </span>
              </div>
              <button 
                onClick={handleLogout}
                className="p-2 text-gray-400 hover:text-white transition-colors"
                title="Logout"
              >
                <LogOut className="w-5 h-5" />
              </button>
            </div>
          ) : (
            <Link 
              to="/login"
              className="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded-full text-sm font-semibold transition-all hover:scale-105 active:scale-95"
            >
              Sign In
            </Link>
          )}
        </div>
      </div>
    </nav>
  );
}
