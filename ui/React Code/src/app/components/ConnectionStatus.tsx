import { Bluetooth, AlertCircle, CheckCircle2, Wifi } from 'lucide-react';
import { Card } from './ui/card';
import { Button } from './ui/button';
import { motion } from 'motion/react';

interface ConnectionStatusProps {
  isConnected: boolean;
  isConnecting: boolean;
  onConnect: () => void;
  onDisconnect: () => void;
}

export function ConnectionStatus({
  isConnected,
  isConnecting,
  onConnect,
  onDisconnect,
}: ConnectionStatusProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
    >
      <Card className="p-6 mb-3 bg-white/90 backdrop-blur-xl border border-gray-200/50 shadow-sm hover:shadow-md transition-shadow">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <motion.div
              className={`p-3 rounded-full relative ${
                isConnected ? 'bg-green-500' : 
                isConnecting ? 'bg-blue-500' : 
                'bg-gray-300'
              }`}
              animate={isConnecting ? {
                scale: [1, 1.05, 1],
              } : {}}
              transition={{
                duration: 1.5,
                repeat: isConnecting ? Infinity : 0,
              }}
            >
              <Bluetooth className="w-5 h-5 text-white" />
            </motion.div>
            <div>
              <p className="font-medium text-gray-900">
                {isConnected ? 'Conectado' : isConnecting ? 'Conectando...' : 'Desconectado'}
              </p>
              <p className="text-sm text-gray-500 flex items-center gap-1">
                {isConnected ? (
                  <>
                    <Wifi className="w-3 h-3" />
                    OBD2 ELM327
                  </>
                ) : (
                  'Dispositivo OBD2'
                )}
              </p>
            </div>
          </div>
          {isConnected ? (
            <Button
              variant="outline"
              size="sm"
              onClick={onDisconnect}
              className="border-gray-300 text-gray-700 hover:bg-gray-50"
            >
              Desconectar
            </Button>
          ) : (
            <Button
              onClick={onConnect}
              disabled={isConnecting}
              className="bg-blue-600 hover:bg-blue-700 text-white shadow-sm"
            >
              {isConnecting ? 'Conectando...' : 'Conectar'}
            </Button>
          )}
        </div>
        {!isConnected && !isConnecting && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            className="mt-4 flex items-start gap-2 p-3 bg-blue-50/50 backdrop-blur-sm rounded-lg border border-blue-100/50"
          >
            <AlertCircle className="w-4 h-4 text-blue-600 mt-0.5 flex-shrink-0" />
            <p className="text-xs text-gray-700">
              Asegúrate de que tu dispositivo OBD2 esté conectado al vehículo y encendido.
            </p>
          </motion.div>
        )}
      </Card>
    </motion.div>
  );
}