import { Sparkles, Wrench, AlertCircle, CheckCircle, Lightbulb } from 'lucide-react';
import { Card } from './ui/card';
import { Badge } from './ui/badge';
import { motion } from 'motion/react';
import { DTCCode } from './DiagnosticCodes';
import { VehicleParameter } from './LiveParameters';

interface Recommendation {
  title: string;
  description: string;
  priority: 'high' | 'medium' | 'low';
  components: string[];
  estimatedCost: string;
}

interface AIRecommendationsProps {
  codes: DTCCode[];
  parameters: VehicleParameter[];
}

export function AIRecommendations({ codes, parameters }: AIRecommendationsProps) {
  // AI Logic para generar recomendaciones basadas en códigos y parámetros
  const generateRecommendations = (): Recommendation[] => {
    const recommendations: Recommendation[] = [];

    // Analizar códigos DTC
    codes.forEach((code) => {
      switch (code.code) {
        case 'P0301':
          recommendations.push({
            title: 'Revisar Sistema de Encendido - Cilindro 1',
            description: 'El fallo de encendido puede deberse a bujías desgastadas, bobinas defectuosas o problemas en los inyectores.',
            priority: 'high',
            components: ['Bujías', 'Bobinas de encendido', 'Inyectores', 'Cables de alta tensión'],
            estimatedCost: '$50 - $300',
          });
          break;
        case 'P0420':
          recommendations.push({
            title: 'Inspección del Catalizador',
            description: 'La eficiencia del catalizador está por debajo del umbral. Puede requerir limpieza o reemplazo.',
            priority: 'medium',
            components: ['Catalizador', 'Sensores de oxígeno', 'Sistema de escape'],
            estimatedCost: '$200 - $1,500',
          });
          break;
        case 'P0171':
          recommendations.push({
            title: 'Verificar Sistema de Combustible',
            description: 'El sistema está funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacío.',
            priority: 'medium',
            components: ['Filtro de aire', 'Sensor MAF', 'Sistema de vacío', 'Inyectores'],
            estimatedCost: '$100 - $400',
          });
          break;
      }
    });

    // Analizar parámetros en tiempo real
    const rpm = parameters.find(p => p.label === 'RPM');
    const temp = parameters.find(p => p.label === 'Temp. Motor');
    const carga = parameters.find(p => p.label === 'Carga Motor');

    if (temp && parseFloat(temp.value) > 100) {
      recommendations.push({
        title: 'Temperatura del Motor Elevada',
        description: 'El motor está operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.',
        priority: 'high',
        components: ['Sistema de refrigeración', 'Termostato', 'Bomba de agua', 'Radiador'],
        estimatedCost: '$80 - $500',
      });
    }

    if (rpm && parseFloat(rpm.value) > 900 && carga && parseFloat(carga.value) < 15) {
      recommendations.push({
        title: 'RPM en Ralentí Irregulares',
        description: 'Las RPM en ralentí están ligeramente elevadas. Puede indicar fugas de vacío o problemas en el cuerpo de aceleración.',
        priority: 'low',
        components: ['Cuerpo de aceleración', 'Válvula IAC', 'Sistema de vacío'],
        estimatedCost: '$60 - $250',
      });
    }

    // Si no hay problemas
    if (recommendations.length === 0) {
      recommendations.push({
        title: 'Vehículo en Buen Estado',
        description: 'No se detectaron problemas críticos. Se recomienda mantenimiento preventivo regular.',
        priority: 'low',
        components: ['Mantenimiento general'],
        estimatedCost: '$50 - $150',
      });
    }

    return recommendations;
  };

  const recommendations = generateRecommendations();

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high':
        return 'bg-red-50/80 border-red-200/50 text-red-700';
      case 'medium':
        return 'bg-orange-50/80 border-orange-200/50 text-orange-700';
      case 'low':
        return 'bg-green-50/80 border-green-200/50 text-green-700';
      default:
        return 'bg-gray-50/80 border-gray-200/50 text-gray-700';
    }
  };

  const getPriorityIcon = (priority: string) => {
    switch (priority) {
      case 'high':
        return <AlertCircle className="w-4 h-4" />;
      case 'medium':
        return <Lightbulb className="w-4 h-4" />;
      case 'low':
        return <CheckCircle className="w-4 h-4" />;
      default:
        return <CheckCircle className="w-4 h-4" />;
    }
  };

  const getPriorityLabel = (priority: string) => {
    switch (priority) {
      case 'high':
        return 'Prioridad Alta';
      case 'medium':
        return 'Prioridad Media';
      case 'low':
        return 'Prioridad Baja';
      default:
        return 'Normal';
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
    >
      <Card className="p-6 mb-3 bg-white/90 backdrop-blur-xl border border-gray-200/50 shadow-sm">
        <div className="flex items-center gap-3 mb-5">
          <div className="p-2.5 bg-gradient-to-br from-purple-50 to-blue-50 rounded-xl">
            <Sparkles className="w-5 h-5 text-purple-600" />
          </div>
          <div className="flex-1">
            <h2 className="text-lg font-medium text-gray-900">Análisis AI</h2>
            <p className="text-xs text-gray-500">Recomendaciones basadas en diagnóstico</p>
          </div>
        </div>

        <div className="space-y-3">
          {recommendations.map((rec, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
              className="p-4 bg-gray-50/50 backdrop-blur-sm rounded-xl border border-gray-200/50"
            >
              <div className="flex items-start gap-3 mb-3">
                <div className="p-2 bg-white rounded-lg">
                  <Wrench className="w-4 h-4 text-gray-600" />
                </div>
                <div className="flex-1">
                  <div className="flex items-start justify-between gap-2 mb-2">
                    <h3 className="font-medium text-gray-900 text-sm">{rec.title}</h3>
                    <Badge 
                      className={`text-xs flex items-center gap-1 ${getPriorityColor(rec.priority)} border`}
                    >
                      {getPriorityIcon(rec.priority)}
                      {getPriorityLabel(rec.priority)}
                    </Badge>
                  </div>
                  <p className="text-xs text-gray-600 leading-relaxed mb-3">
                    {rec.description}
                  </p>
                  
                  <div className="space-y-2">
                    <div>
                      <p className="text-xs font-medium text-gray-700 mb-1.5">
                        Componentes a revisar:
                      </p>
                      <div className="flex flex-wrap gap-1.5">
                        {rec.components.map((component, idx) => (
                          <span
                            key={idx}
                            className="text-xs px-2 py-1 bg-white border border-gray-200 rounded-md text-gray-700"
                          >
                            {component}
                          </span>
                        ))}
                      </div>
                    </div>
                    
                    <div className="flex items-center justify-between pt-2 border-t border-gray-200">
                      <p className="text-xs text-gray-500">Costo estimado</p>
                      <p className="text-xs font-semibold text-gray-900">{rec.estimatedCost}</p>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5 }}
          className="mt-4 p-3 bg-purple-50/50 backdrop-blur-sm rounded-lg border border-purple-100/50"
        >
          <div className="flex items-start gap-2">
            <Sparkles className="w-4 h-4 text-purple-600 mt-0.5 flex-shrink-0" />
            <p className="text-xs text-gray-700">
              <span className="font-medium">Análisis generado por IA:</span> Las recomendaciones se basan en los códigos de diagnóstico actuales y parámetros del vehículo. Consulta con un mecánico certificado para confirmación.
            </p>
          </div>
        </motion.div>
      </Card>
    </motion.div>
  );
}
