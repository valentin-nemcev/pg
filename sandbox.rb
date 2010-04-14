#!/usr/bin/env script/runner

 p Article.find(639).convert_legacy_fields.save!
# p Article.find(91).text

# p Russian.translit('Оппозиция: издержки роста или карлик навсегда?').parameterize
# p 'a' * 120