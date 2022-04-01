//
//  pdfCreator.swift
//  OClock
//
//  Created by Rafael Hartmann on 20/03/22.
//

import Foundation
import SimplePDF
import PDFKit

class PDFCreator {
    
    var month: String
    var reportData: [ReportModel]
    
    init(monthI: String, reportDataI: [ReportModel]) {
        month = monthI
        reportData = reportDataI
    }
    
    func createPDF(totalHours: String) -> Data {
        let a4PaperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: a4PaperSize)
        
        pdf.setContentAlignment(.left)
       
        pdf.addText("\(month)", font: UIFont(name: RFontsK.QuicksandBold, size: 42) ?? UIFont.boldSystemFont(ofSize: 21))
        pdf.addLineSpace(24)
        
        pdf.setContentAlignment(.left)
        
        pdf.addText("Horas totais do mes: \(totalHours)")
        
        pdf.addLineSpace(12)
        
        pdf.addLineSeparator()
        
        pdf.addLineSpace(12)
        
        for rep in reportData {
          
           pdf.addText(
"""
Dia de inicio: \(rep.initialDay ?? "") - \(rep.initialWeekday.weekDay())
Dia de encerramento: \(rep.endDay ?? "") - \(rep.endWeekday.weekDay())
Hora de inicio: \(rep.initialHours ?? "")
Hora de encenrramento: \(rep.endHours ?? "")
Total de intervalo: \(rep.intervalTotalHours.toSec())
Total trabalhado: \(rep.totalHours.toSec())
""", font: UIFont(name: RFontsK.QuicksandSemiBold, size: 16) ?? UIFont.boldSystemFont(ofSize: 12))
            pdf.addLineSpace(12)
            pdf.addLineSeparator()
            pdf.addLineSpace(12)
          
       }
        pdf.setContentAlignment(.center)
        pdf.addText("Relatório gerado pelo App: O`Clock", font: UIFont(name: RFontsK.QuicksandLight, size: 6) ?? UIFont.systemFont(ofSize: 6))
        let pdfData = pdf.generatePDFdata()
        return pdfData
    }
}