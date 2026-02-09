import { Car, Info, Shield, Cpu } from 'lucide-react';
import { Card } from './ui/card';
import { motion } from 'motion/react';

interface VehicleInfoProps {
  vin: string;
  protocol: string;
  ecuCount: number;
}

export function VehicleInfo({ vin, protocol, ecuCount }: VehicleInfoProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.1 }}
    >
      <Card className="p-6 mb-3 bg-white/90 backdrop-blur-xl border border-gray-200/50 shadow-sm">
        <div className="flex items-start gap-4 mb-4">
          <div className="p-3 bg-blue-50 rounded-full">
            <Car className="w-6 h-6 text-blue-600" />
          </div>
          <div className="flex-1">
            <h2 className="font-medium text-gray-900 mb-1">Información del Vehículo</h2>
            <p className="text-xs text-gray-500">Datos del sistema OBD2</p>
          </div>
        </div>
        
        <div className="space-y-2">
          <div className="flex items-center justify-between p-3 bg-gray-50/50 backdrop-blur-sm rounded-lg border border-gray-200/50">
            <span className="text-sm text-gray-600 flex items-center gap-2">
              <Shield className="w-4 h-4 text-gray-400" />
              VIN
            </span>
            <span className="font-mono text-sm font-medium text-gray-900">{vin}</span>
          </div>
          <div className="flex items-center justify-between p-3 bg-gray-50/50 backdrop-blur-sm rounded-lg border border-gray-200/50">
            <span className="text-sm text-gray-600 flex items-center gap-2">
              <Info className="w-4 h-4 text-gray-400" />
              Protocolo
            </span>
            <span className="text-xs font-medium text-gray-900">{protocol}</span>
          </div>
          <div className="flex items-center justify-between p-3 bg-gray-50/50 backdrop-blur-sm rounded-lg border border-gray-200/50">
            <span className="text-sm text-gray-600 flex items-center gap-2">
              <Cpu className="w-4 h-4 text-gray-400" />
              ECUs Detectadas
            </span>
            <span className="text-sm font-medium text-gray-900">{ecuCount}</span>
          </div>
        </div>
        
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.3 }}
          className="mt-4 flex items-start gap-2 p-3 bg-blue-50/50 backdrop-blur-sm rounded-lg border border-blue-100/50"
        >
          <Info className="w-4 h-4 text-blue-600 mt-0.5 flex-shrink-0" />
          <p className="text-xs text-gray-700">
            Los datos se actualizan cada 2 segundos
          </p>
        </motion.div>
      </Card>
    </motion.div>
  );
}