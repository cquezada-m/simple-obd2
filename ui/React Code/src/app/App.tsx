import { useState, useEffect } from 'react';
import { ConnectionStatus } from './components/ConnectionStatus';
import { DiagnosticCodes, DTCCode } from './components/DiagnosticCodes';
import { LiveParameters, VehicleParameter } from './components/LiveParameters';
import { VehicleInfo } from './components/VehicleInfo';
import { AIRecommendations } from './components/AIRecommendations';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './components/ui/tabs';
import { Activity, AlertTriangle, Car, Sparkles } from 'lucide-react';
import { toast } from 'sonner';
import { Toaster } from './components/ui/sonner';
import { motion, AnimatePresence } from 'motion/react';

function App() {
  const [isConnected, setIsConnected] = useState(false);
  const [isConnecting, setIsConnecting] = useState(false);
  const [isClearing, setIsClearing] = useState(false);
  const [activeTab, setActiveTab] = useState('diagnostics');

  // Mock diagnostic codes
  const [dtcCodes, setDtcCodes] = useState<DTCCode[]>([
    {
      code: 'P0301',
      description: 'Fallo de encendido en cilindro 1',
      severity: 'critical',
    },
    {
      code: 'P0420',
      description: 'Catalizador sistema bajo eficiencia',
      severity: 'warning',
    },
    {
      code: 'P0171',
      description: 'Sistema demasiado pobre (Banco 1)',
      severity: 'warning',
    },
  ]);

  // Mock live parameters with simulated values
  const [liveParams, setLiveParams] = useState<VehicleParameter[]>([
    {
      label: 'RPM',
      value: '850',
      unit: 'rpm',
      icon: 'gauge',
      percentage: 14,
      color: 'bg-purple-100 text-purple-600',
    },
    {
      label: 'Velocidad',
      value: '0',
      unit: 'km/h',
      icon: 'activity',
      percentage: 0,
      color: 'bg-blue-100 text-blue-600',
    },
    {
      label: 'Temp. Motor',
      value: '92',
      unit: '°C',
      icon: 'thermometer',
      percentage: 73,
      color: 'bg-red-100 text-red-600',
    },
    {
      label: 'Carga Motor',
      value: '18',
      unit: '%',
      icon: 'zap',
      percentage: 18,
      color: 'bg-yellow-100 text-yellow-600',
    },
    {
      label: 'Presión Admisión',
      value: '29',
      unit: 'kPa',
      icon: 'wind',
      percentage: 29,
      color: 'bg-cyan-100 text-cyan-600',
    },
    {
      label: 'Nivel Combustible',
      value: '68',
      unit: '%',
      icon: 'droplets',
      percentage: 68,
      color: 'bg-green-100 text-green-600',
    },
  ]);

  // Mock vehicle info
  const vehicleInfo = {
    vin: '1HGBH41JXMN109186',
    protocol: 'ISO 15765-4 (CAN 11/500)',
    ecuCount: 7,
  };

  // Simulate connection
  const handleConnect = () => {
    setIsConnecting(true);
    toast.loading('Buscando dispositivo OBD2...', { id: 'connecting' });
    
    setTimeout(() => {
      setIsConnecting(false);
      setIsConnected(true);
      toast.success('Conectado exitosamente al OBD2', { id: 'connecting' });
    }, 2000);
  };

  const handleDisconnect = () => {
    setIsConnected(false);
    toast.info('Desconectado del dispositivo OBD2');
  };

  // Simulate clearing codes
  const handleClearCodes = () => {
    setIsClearing(true);
    toast.loading('Borrando códigos...', { id: 'clearing' });
    
    setTimeout(() => {
      setDtcCodes([]);
      setIsClearing(false);
      toast.success('Códigos borrados exitosamente', { id: 'clearing' });
    }, 2000);
  };

  // Simulate live parameter updates
  useEffect(() => {
    if (!isConnected) return;

    const interval = setInterval(() => {
      setLiveParams((prev) =>
        prev.map((param) => {
          let newValue = parseFloat(param.value);
          let percentage = param.percentage || 0;

          switch (param.label) {
            case 'RPM':
              newValue = 800 + Math.random() * 200;
              percentage = (newValue / 6000) * 100;
              break;
            case 'Temp. Motor':
              newValue = 88 + Math.random() * 8;
              percentage = (newValue / 125) * 100;
              break;
            case 'Carga Motor':
              newValue = 15 + Math.random() * 10;
              percentage = newValue;
              break;
            case 'Presión Admisión':
              newValue = 25 + Math.random() * 10;
              percentage = (newValue / 100) * 100;
              break;
            case 'Nivel Combustible':
              newValue = Math.max(65, param.percentage! - 0.01);
              percentage = newValue;
              break;
            default:
              break;
          }

          return {
            ...param,
            value: Math.round(newValue).toString(),
            percentage: Math.min(100, Math.max(0, percentage)),
          };
        })
      );
    }, 2000);

    return () => clearInterval(interval);
  }, [isConnected]);

  return (
    <div className="min-h-screen bg-white pb-safe">
      <Toaster position="top-center" richColors />
      
      {/* Header */}
      <div className="bg-white border-b border-gray-200/50 backdrop-blur-xl sticky top-0 z-50 shadow-sm">
        <div className="max-w-md mx-auto px-6 py-4">
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex items-center gap-3"
          >
            <div className="p-2.5 bg-blue-50 rounded-xl">
              <Car className="w-6 h-6 text-blue-600" />
            </div>
            <div>
              <h1 className="text-xl font-semibold text-gray-900">OBD2 Scanner</h1>
              <p className="text-xs text-gray-500">Diagnóstico de Vehículo</p>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-md mx-auto px-4 py-4">
        <ConnectionStatus
          isConnected={isConnected}
          isConnecting={isConnecting}
          onConnect={handleConnect}
          onDisconnect={handleDisconnect}
        />

        <AnimatePresence mode="wait">
          {isConnected ? (
            <motion.div
              key="connected"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              <VehicleInfo
                vin={vehicleInfo.vin}
                protocol={vehicleInfo.protocol}
                ecuCount={vehicleInfo.ecuCount}
              />

              <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
                <TabsList className="grid w-full grid-cols-2 mb-3 p-1 bg-gray-100/50 backdrop-blur-sm border border-gray-200/50">
                  <TabsTrigger 
                    value="diagnostics" 
                    className="flex items-center gap-2 rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm"
                  >
                    <AlertTriangle className="w-4 h-4" />
                    Diagnóstico
                    {dtcCodes.length > 0 && (
                      <motion.span
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        className="bg-red-600 text-white text-xs font-semibold px-1.5 py-0.5 rounded-full min-w-[20px] text-center"
                      >
                        {dtcCodes.length}
                      </motion.span>
                    )}
                  </TabsTrigger>
                  <TabsTrigger 
                    value="live" 
                    className="flex items-center gap-2 rounded-lg data-[state=active]:bg-white data-[state=active]:shadow-sm"
                  >
                    <Activity className="w-4 h-4" />
                    En Vivo
                  </TabsTrigger>
                </TabsList>

                <TabsContent value="diagnostics" className="mt-0">
                  <DiagnosticCodes
                    codes={dtcCodes}
                    onClearCodes={handleClearCodes}
                    isClearing={isClearing}
                  />
                  
                  <AIRecommendations 
                    codes={dtcCodes} 
                    parameters={liveParams}
                  />
                </TabsContent>

                <TabsContent value="live" className="mt-0">
                  <LiveParameters parameters={liveParams} />
                  
                  <AIRecommendations 
                    codes={dtcCodes} 
                    parameters={liveParams}
                  />
                </TabsContent>
              </Tabs>
            </motion.div>
          ) : (
            <motion.div
              key="disconnected"
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="text-center py-20"
            >
              <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Car className="w-10 h-10 text-gray-400" />
              </div>
              <h3 className="font-medium text-gray-900 mb-2">
                Conecta tu dispositivo OBD2
              </h3>
              <p className="text-sm text-gray-500 max-w-xs mx-auto leading-relaxed">
                Conecta el escáner al puerto de diagnóstico de tu vehículo y presiona conectar
              </p>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </div>
  );
}

export default App;