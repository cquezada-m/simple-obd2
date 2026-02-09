import { AlertTriangle, CheckCircle2, X, AlertOctagon, Info } from 'lucide-react';
import { Card } from './ui/card';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { motion, AnimatePresence } from 'motion/react';

export interface DTCCode {
  code: string;
  description: string;
  severity: 'critical' | 'warning' | 'info';
}

interface DiagnosticCodesProps {
  codes: DTCCode[];
  onClearCodes: () => void;
  isClearing: boolean;
}

export function DiagnosticCodes({ codes, onClearCodes, isClearing }: DiagnosticCodesProps) {
  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case 'critical':
        return 'bg-red-50/80 border-red-200/50';
      case 'warning':
        return 'bg-orange-50/80 border-orange-200/50';
      case 'info':
        return 'bg-blue-50/80 border-blue-200/50';
      default:
        return 'bg-gray-50/80 border-gray-200/50';
    }
  };

  const getSeverityIcon = (severity: string) => {
    const iconColor = severity === 'critical' ? 'text-red-600' : 
                      severity === 'warning' ? 'text-orange-600' : 
                      'text-blue-600';
    switch (severity) {
      case 'critical':
        return <AlertOctagon className={`w-5 h-5 ${iconColor}`} />;
      case 'warning':
        return <AlertTriangle className={`w-5 h-5 ${iconColor}`} />;
      default:
        return <Info className={`w-5 h-5 ${iconColor}`} />;
    }
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
            Códigos de Diagnóstico
          </h2>
          {codes.length > 0 && (
            <Button
              variant="outline"
              size="sm"
              onClick={onClearCodes}
              disabled={isClearing}
              className="text-red-600 hover:bg-red-50 border-gray-300"
            >
              {isClearing ? 'Borrando...' : 'Borrar'}
            </Button>
          )}
        </div>

        <AnimatePresence mode="wait">
          {codes.length === 0 ? (
            <motion.div
              key="no-codes"
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="text-center py-12"
            >
              <div className="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center mx-auto mb-3">
                <CheckCircle2 className="w-8 h-8 text-green-600" />
              </div>
              <p className="font-medium text-gray-900">Sin códigos de error</p>
              <p className="text-sm text-gray-500 mt-1">El sistema está funcionando correctamente</p>
            </motion.div>
          ) : (
            <motion.div
              key="codes-list"
              className="space-y-2"
            >
              {codes.map((code, index) => (
                <motion.div
                  key={code.code}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: 20 }}
                  transition={{ delay: index * 0.05 }}
                  className={`p-4 rounded-xl border backdrop-blur-sm ${getSeverityColor(code.severity)}`}
                >
                  <div className="flex items-start gap-3">
                    {getSeverityIcon(code.severity)}
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-1">
                        <span className="font-mono font-semibold text-gray-900">{code.code}</span>
                        <Badge 
                          variant="outline" 
                          className="text-xs border-gray-300 bg-white/50"
                        >
                          {code.severity === 'critical' ? 'Crítico' : 
                           code.severity === 'warning' ? 'Advertencia' : 'Info'}
                        </Badge>
                      </div>
                      <p className="text-sm text-gray-700 leading-relaxed">{code.description}</p>
                    </div>
                  </div>
                </motion.div>
              ))}
            </motion.div>
          )}
        </AnimatePresence>
      </Card>
    </motion.div>
  );
}