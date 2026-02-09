import { Activity, Gauge, Thermometer, Droplets, Zap, Wind } from 'lucide-react';
import { Card } from './ui/card';
import { Progress } from './ui/progress';
import { motion } from 'motion/react';

export interface VehicleParameter {
  label: string;
  value: string;
  unit: string;
  icon: 'gauge' | 'thermometer' | 'droplets' | 'activity' | 'zap' | 'wind';
  percentage?: number;
  color?: string;
}

interface LiveParametersProps {
  parameters: VehicleParameter[];
}

export function LiveParameters({ parameters }: LiveParametersProps) {
  const getIcon = (iconName: string) => {
    const iconClass = "w-5 h-5 text-gray-700";
    switch (iconName) {
      case 'gauge':
        return <Gauge className={iconClass} />;
      case 'thermometer':
        return <Thermometer className={iconClass} />;
      case 'droplets':
        return <Droplets className={iconClass} />;
      case 'activity':
        return <Activity className={iconClass} />;
      case 'zap':
        return <Zap className={iconClass} />;
      case 'wind':
        return <Wind className={iconClass} />;
      default:
        return <Activity className={iconClass} />;
    }
  };

  const getProgressColor = (percentage: number) => {
    if (percentage > 80) return 'bg-red-500';
    if (percentage > 60) return 'bg-orange-500';
    if (percentage > 40) return 'bg-blue-500';
    return 'bg-green-500';
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.3 }}
    >
      <Card className="p-6 mb-3 bg-white/90 backdrop-blur-xl border border-gray-200/50 shadow-sm">
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-lg font-medium text-gray-900">
            Parámetros en Tiempo Real
          </h2>
          <motion.div
            animate={{ scale: [1, 1.2, 1], opacity: [1, 0.5, 1] }}
            transition={{ duration: 2, repeat: Infinity }}
            className="w-2 h-2 bg-green-500 rounded-full"
          />
        </div>

        <div className="grid grid-cols-2 gap-3">
          {parameters.map((param, index) => (
            <motion.div
              key={param.label}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: index * 0.03 }}
            >
              <Card className="p-4 bg-gray-50/50 backdrop-blur-sm border border-gray-200/50 hover:bg-gray-50 transition-colors">
                <div className="flex items-center gap-2 mb-3">
                  {getIcon(param.icon)}
                  <span className="text-xs font-medium text-gray-600">{param.label}</span>
                </div>
                <div className="mb-2">
                  <motion.span
                    key={param.value}
                    initial={{ scale: 1.1, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    className="text-3xl font-semibold text-gray-900"
                  >
                    {param.value}
                  </motion.span>
                  <span className="text-sm text-gray-500 ml-1 font-medium">{param.unit}</span>
                </div>
                {param.percentage !== undefined && (
                  <div className="relative h-1.5 bg-gray-200 rounded-full overflow-hidden">
                    <motion.div
                      initial={{ width: 0 }}
                      animate={{ width: `${param.percentage}%` }}
                      transition={{ duration: 0.5, ease: "easeOut" }}
                      className={`h-full rounded-full ${getProgressColor(param.percentage)}`}
                    />
                  </div>
                )}
              </Card>
            </motion.div>
          ))}
        </div>
      </Card>
    </motion.div>
  );
}