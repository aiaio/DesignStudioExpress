//
//  PostDesignStudioViewModel.swift
//  DesignStudioExpress
//
//  Created by Kristijan Perusko on 12/14/15.
//  Copyright © 2015 Alexander Interactive. All rights reserved.
//

class PostDesignStudioViewModel {
    private var data: DesignStudio!
    
    var designStudioTitle: String {
        get { return data.title }
    }
    
    func setDesignStudio(designStudio: DesignStudio) {
        self.data = designStudio
    }
}
