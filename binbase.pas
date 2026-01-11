unit binbase;

interface

     {ELF32 Basic data type}
type elf32_address=dword;
     elf32_offset=dword;
     elf32_halfword=word;
     elf32_word=dword;
     elf32_sword=Integer;
     elf32_xword=qword;
     elf32_sxword=int64;
     elf32_section=word;
     elf32_version_symbol=word;
     {ELF64 Basic data type}
     elf64_address=qword;
     elf64_offset=qword;
     elf64_halfword=word;
     elf64_word=dword;
     elf64_sword=Integer;
     elf64_xword=qword;
     elf64_sxword=Int64;
     elf64_section=word;
     elf64_version_symbol=word;
     {ELF File Id}
     elf_file_id=array[1..16] of byte;
     {ELF32 File Header}
     elf32_header=packed record
                  elf_id:array[1..16] of byte;
                  elf_type:elf32_halfword;
                  elf_machine:elf32_halfword;
                  elf_version:elf32_word;
                  elf_entry:elf32_address;
                  elf_program_header_offset:elf32_offset;
                  elf_section_header_offset:elf32_offset;
                  elf_flags:elf32_word;
                  elf_header_size:elf32_halfword;
                  elf_program_header_size:elf32_halfword;
                  elf_program_header_number:elf32_halfword;
                  elf_section_header_size:elf32_halfword;
                  elf_section_header_number:elf32_halfword;
                  elf_section_header_string_table_index:elf32_halfword;
                  end;
     Pelf32_header=^elf32_header;
     {ELF64 File Header}
     elf64_header=packed record
                  elf_id:array[1..16] of byte;
                  elf_type:elf64_halfword;
                  elf_machine:elf64_halfword;
                  elf_version:elf64_word;
                  elf_entry:elf64_address;
                  elf_program_header_offset:elf64_offset;
                  elf_section_header_offset:elf64_offset;
                  elf_flags:elf64_word;
                  elf_header_size:elf64_halfword;
                  elf_program_header_size:elf64_halfword;
                  elf_program_header_number:elf64_halfword;
                  elf_section_header_size:elf64_halfword;
                  elf_section_header_number:elf64_halfword;
                  elf_section_header_string_table_index:elf64_halfword;
                  end;
     Pelf64_header=^elf64_header;
     {ELF32 File Section Header}
     elf32_section_header=packed record
                          section_header_name:elf32_word;
                          section_header_type:elf32_word;
                          section_header_flags:elf32_word;
                          section_header_address:elf32_address;
                          section_header_offset:elf32_offset;
                          section_header_size:elf32_word;
                          section_header_link:elf32_word;
                          section_header_info:elf32_word;
                          section_header_address_align:elf32_word;
                          section_header_entry_size:elf32_word;
                          end;
     Pelf32_section_header=^elf32_section_header;
     {ELF64 File Section Header}
     elf64_section_header=packed record
                          section_header_name:elf64_word;
                          section_header_type:elf64_word;
                          section_header_flags:elf64_xword;
                          section_header_address:elf64_address;
                          section_header_offset:elf64_offset;
                          section_header_size:elf64_xword;
                          section_header_link:elf64_word;
                          section_header_info:elf64_word;
                          section_header_address_align:elf64_xword;
                          section_header_entry_size:elf64_xword;
                          end;
     Pelf64_section_header=^elf64_section_header;
     {ELF32 Compression Header}
     elf32_compression_header=packed record
                              compression_header_type:elf32_word;
                              uncompression_size:elf32_word;
                              uncompression_data_alignment:elf32_word;
                              end;
     Pelf32_compression_header=^elf32_compression_header;
     {ELF64 Compression Header}
     elf64_compression_header=packed record
                              compression_header_type:elf64_word;
                              reserved:elf64_word;
                              uncompression_size:elf64_xword;
                              uncompression_data_alignment:elf64_xword;
                              end;
     Pelf64_compression_header=^elf64_compression_header;
     {ELF32 Symbol Table Entry}
     elf32_symbol_table_entry=packed record
                              symbol_name:elf32_word;
                              symbol_value:elf32_address;
                              symbol_size:elf32_word;
                              symbol_info:byte;
                              symbol_other:byte;
                              symbol_section_index:elf32_section;
                              end;
     Pelf32_symbol_table_entry=^elf32_symbol_table_entry;
     {ELF64 Symbol Table Entry}
     elf64_symbol_table_entry=packed record
                              symbol_name:elf64_word;
                              symbol_info:byte;
                              symbol_other:byte;
                              symbol_section_index:elf64_section;
                              symbol_value:elf64_address;
                              symbol_size:elf64_xword;
                              end;
     Pelf64_symbol_table_entry=^elf64_symbol_table_entry;
     {ELF32 Symbol Info Section}
     elf32_symbol_info=packed record
                       symbol_info_bound_to:elf32_halfword;
                       symbol_info_flags:elf32_halfword;
                       end;
     Pelf32_symbol_info=^elf32_symbol_info;
     {ELF64 Symbol Info Section}
     elf64_symbol_info=packed record
                       symbol_info_bound_to:elf64_halfword;
                       symbol_info_flags:elf64_halfword;
                       end;
     Pelf64_symbol_info=^elf64_symbol_info;
     {ELF32 Relocation Table Entry}
     elf32_rel=packed record
               Offset:elf32_address;
               Info:elf32_word;
               end;
     Pelf32_rel=^elf32_rel;
     {ELF64 Relocation Table Entry}
     elf64_rel=packed record
               Offset:elf64_address;
               Info:elf64_word;
               end;
     Pelf64_rel=^elf64_rel;
     {ELF32 Relocation Table Entry With addend}
     elf32_rela=packed record
                Offset:elf32_address;
                Info:elf32_word;
                Addend:elf32_sword;
                end;
     Pelf32_rela=^elf32_rela;
     {ELF64 Relocation Table Entry With addend}
     elf64_rela=packed record
                Offset:elf64_address;
                Info:elf64_xword;
                Addend:elf64_sxword;
                end;
     Pelf64_rela=^elf64_rela;
     {ELF32 RELR Relocation Table Entry}
     elf32_relr=elf32_word;
     {ELF64 RELR Relocation Table Entry}
     elf64_relr=elf64_xword;
     {ELF32 Program Header}
     elf32_program_header=packed record
                          program_type:elf32_word;
                          program_offset:elf32_offset;
                          program_virtual_address:elf32_address;
                          program_physical_address:elf32_address;
                          program_file_size:elf32_word;
                          program_memory_size:elf32_word;
                          program_flags:elf32_word;
                          program_align:elf32_word;
                          end;
     Pelf32_program_header=^elf32_program_header;
     {ELF64 Program Header}
     elf64_program_header=packed record
                          program_type:elf64_word;
                          program_flags:elf64_word;
                          program_offset:elf64_offset;
                          program_virtual_address:elf64_address;
                          program_physical_address:elf64_address;
                          program_file_size:elf64_xword;
                          program_memory_size:elf64_xword;
                          program_align:elf64_xword;
                          end;
     Pelf64_program_header=^elf64_program_header;
     {ELF32 Dynamic Section Entry}
     elf32_dynamic_entry=packed record
                         dynamic_entry_type:elf32_sword;
                         case Boolean of
                         True:(dynamic_value:elf32_word;);
                         False:(dynamic_pointer:elf32_address;);
                         end;
     Pelf32_dynamic_entry=^elf32_dynamic_entry;
     {ELF64 Dynamic Section Entry}
     elf64_dynamic_entry=packed record
                         dynamic_entry_type:elf64_sxword;
                         case Boolean of
                         True:(dynamic_value:elf64_xword;);
                         False:(dynamic_pointer:elf64_address;);
                         end;
     Pelf64_dynamic_entry=^elf64_dynamic_entry;
     {ELF32 Version Definition Entry}
     elf32_version_definition_section=packed record
                                      Version_Definition_Version:elf32_halfword;
                                      Version_Definition_Flags:elf32_halfword;
                                      Version_Definition_Index:elf32_halfword;
                                      Version_Definition_Count:elf32_halfword;
                                      Version_Definition_Hash_Value:elf32_word;
                                      Version_Definition_Aux_Value:elf32_word;
                                      Version_Definition_Next:elf32_word;
                                      end;
     Pelf32_version_definition_section=^elf32_version_definition_section;
     {ELF64 Version Definition Entry}
     elf64_version_definition_section=packed record
                                      Version_Definition_Version:elf64_halfword;
                                      Version_Definition_Flags:elf64_halfword;
                                      Version_Definition_Index:elf64_halfword;
                                      Version_Definition_Count:elf64_halfword;
                                      Version_Definition_Hash_Value:elf64_word;
                                      Version_Definition_Aux_Value:elf64_word;
                                      Version_Definition_Next:elf64_word;
                                      end;
     Pelf64_version_definition_section=^elf64_version_definition_section;
     {ELF32 Auxiliary Version Information}
     elf32_auxiliary_version_definition_section=packed record
                                                Auxiliary_Name:elf32_word;
                                                Auxiliary_Next_Offset:elf32_word;
                                                end;
     Pelf32_auxiliary_version_definition_section=^elf32_auxiliary_version_definition_section;
     {ELF64 Auxiliary Version Information}
     elf64_auxiliary_version_definition_section=packed record
                                                Auxiliary_Name:elf64_word;
                                                Auxiliary_Next_Offset:elf64_word;
                                                end;
     Pelf64_auxiliary_version_definition_section=^elf64_auxiliary_version_definition_section;
     {ELF32 Version Needed Information}
     elf32_version_needed_section=packed record
                                  Version:elf32_halfword;
                                  Count:elf32_halfword;
                                  FileNameOffset:elf32_word;
                                  AuxiliaryArrayOffset:elf32_word;
                                  NextVersionNeededEntry:elf32_word;
                                  end;
     Pelf32_version_needed_section=^elf32_version_needed_section;
     {ELF64 Version Needed Information}
     elf64_version_needed_section=packed record
                                  Version:elf64_halfword;
                                  Count:elf64_halfword;
                                  FileNameOffset:elf64_word;
                                  AuxiliaryArrayOffset:elf64_word;
                                  NextVersionNeededEntry:elf64_word;
                                  end;
     Pelf64_version_needed_section=^elf64_version_needed_section;
     {ELF32 Auxiliary Version Needed Information}
     elf32_version_needed_auxiliary=packed record
                                    Auxiliary_Hash:elf32_word;
                                    Auxiliary_Flags:elf32_halfword;
                                    Auxiliary_Other:elf32_halfword;
                                    Auxiliary_Name:elf32_word;
                                    Auxiliary_Next_Offset:elf32_word;
                                    end;
     Pelf32_version_needed_auxiliary=^elf32_version_needed_auxiliary;
     {ELF64 Auxiliary Version Needed Information}
     elf64_version_needed_auxiliary=packed record
                                    Auxiliary_Hash:elf64_word;
                                    Auxiliary_Flags:elf64_halfword;
                                    Auxiliary_Other:elf64_halfword;
                                    Auxiliary_Name:elf64_word;
                                    Auxiliary_Next_Offset:elf64_word;
                                    end;
     Pelf64_version_needed_auxiliary=^elf64_version_needed_auxiliary;
     {ELF32 Auxiliary Vector}
     elf32_auxilitary_vector=packed record
                             Auxiliary_Type:dword;
                             Auxiliary_Value:dword;
                             end;
     Pelf32_auxilitary_vector=^elf32_auxilitary_vector;
     {ELF64 Auxiliary Vector}
     elf64_auxilitary_vector=packed record
                             Auxiliary_Type:qword;
                             Auxiliary_Value:qword;
                             end;
     Pelf64_auxilitary_vector=^elf64_auxilitary_vector;
     {ELF32 Note Section Content}
     elf32_note_section_header=packed record
                               Name_Length:elf32_word;
                               Descriptor_Length:elf32_word;
                               Note_Type:elf32_word;
                               end;
     Pelf32_note_section_header=^elf32_note_section_header;
     {ELF64 Note Section Content}
     elf64_note_section_header=packed record
                               Name_Length:elf64_word;
                               Descriptor_Length:elf64_word;
                               Note_Type:elf64_word;
                               end;
     Pelf64_note_section_header=^elf64_note_section_header;
     {ELF32 Move Record}
     elf32_move_record=packed record
                       Move_Symbol_Value:elf32_xword;
                       Move_Info:elf32_word;
                       Move_Offset:elf32_word;
                       Move_Repeat_Count:elf32_halfword;
                       Move_Stride:elf32_halfword;
                       end;
     Pelf32_move_record=^elf32_move_record;
     {ELF64 Move Record}
     elf64_move_record=packed record
                       Move_Symbol_Value:elf64_xword;
                       Move_Info:elf64_xword;
                       Move_Offset:elf64_xword;
                       Move_Repeat_Count:elf64_halfword;
                       Move_Stride:elf64_halfword;
                       end;
     Pelf64_move_record=^elf64_move_record;
     {ELF32 TLS Descriptor}
     elf32_tls_descriptor=packed record
                          ParseFunc:elf32_address;
                          Argument:elf32_address;
                          end;
     Pelf32_tls_descriptor=^elf32_tls_descriptor;
     {ELF64 TLS Descriptor}
     elf64_tls_descriptor=packed record
                          ParseFunc:elf64_address;
                          Argument:elf64_address;
                          end;
     Pelf64_tls_descriptor=^elf64_tls_descriptor;
     {ELF Archive File Data Structure}
     elf_archive_file_header=packed record
                             ArchiveName:array[1..16] of char;
                             ArchiveDate:array[1..12] of char;
                             ArchiveUid,ArchiveGid:array[1..6] of char;
                             ArchiveMode:array[1..8] of char;
                             ArchiveSize:array[1..10] of char;
                             ArchiveFileMagic:array[1..2] of char;
                             end;
     Pelf_archive_file_header=^elf_archive_file_header;
     {PE DOS Header}
     pe_dos_header=packed record
                   MagicNumber:array[1..2] of char;
                   BytesOnLastPageOfFile:word;
                   PagesInFile:word;
                   Relocation:word;
                   SizeOfHeaderInParagraphs:word;
                   MinimumExtraParagraphNeeded:word;
                   MaximumExtraParagraphNeeded:word;
                   InitialRelativeSSValue:word;
                   InitialSPValue:word;
                   Checksum:word;
                   InitialIPValue:word;
                   InitialRelativeCSValue:word;
                   FileAddressOfRelocationTable:word;
                   OverlayNumber:word;
                   ReservedWords:array[1..4] of word;
                   OemId:word;
                   OemInformation:word;
                   ReservedWords2:array[1..10] of word;
                   FileAddressOfNewExeHeader:dword;
                   end;
     Ppe_dos_header=^pe_dos_header;
     {PE/COFF Image Headers}
     coff_image_header=packed record
                       Machine:word;
                       NumberOfSections:word;
                       TimeDateStamp:dword;
                       PointerToSymbolTable:dword;
                       NumberOfSymbols:dword;
                       SizeOfOptionalHeader:word;
                       Characteristics:word;
                       end;
     Pcoff_image_header=^coff_image_header;
     coff_optional_image_header32=packed record
                                  MagicNumber:word;
                                  MajorLinkerVersion:byte;
                                  MinorLinkerVersion:byte;
                                  SizeOfCode:dword;
                                  SizeOfInitializedData:dword;
                                  SizeOfUnInitializedData:dword;
                                  AddressOfEntryPoint:dword;
                                  BaseOfCode:dword;
                                  BaseOfData:dword;
                                  ImageBase:dword;
                                  SectionAlignment:dword;
                                  FileAlignment:dword;
                                  MajorOperatingSystemVersion:word;
                                  MinorOperatingSystemVersion:word;
                                  MajorImageVersion:word;
                                  MinorImageVersion:word;
                                  MajorSubSystemVersion:word;
                                  MinorSubSystemVersion:word;
                                  Win32VersionValue:dword;
                                  SizeOfImage:dword;
                                  SizeOfHeaders:dword;
                                  CheckSum:dword;
                                  SubSystem:word;
                                  DLLCharacteristics:word;
                                  SizeOfStackReserve:dword;
                                  SizeOfStackCommit:dword;
                                  SizeOfHeapReserve:dword;
                                  SizeOfHeapCommit:dword;
                                  LoaderFlags:dword;
                                  NumberOfRvaAndSizes:dword;
                                  end;
     Pcoff_optional_image_header32=^coff_optional_image_header32;
     coff_optional_image_header64=packed record
                                  MagicNumber:word;
                                  MajorLinkerVersion:byte;
                                  MinorLinkerVersion:byte;
                                  SizeOfCode:dword;
                                  SizeOfInitializedData:dword;
                                  SizeOfUnInitializedData:dword;
                                  AddressOfEntryPoint:dword;
                                  BaseOfCode:dword;
                                  ImageBase:qword;
                                  SectionAlignment:dword;
                                  FileAlignment:dword;
                                  MajorOperatingSystemVersion:word;
                                  MinorOperatingSystemVersion:word;
                                  MajorImageVersion:word;
                                  MinorImageVersion:word;
                                  MajorSubSystemVersion:word;
                                  MinorSubSystemVersion:word;
                                  Win32VersionValue:dword;
                                  SizeOfImage:dword;
                                  SizeOfHeaders:dword;
                                  CheckSum:dword;
                                  SubSystem:word;
                                  DLLCharacteristics:word;
                                  SizeOfStackReserve:qword;
                                  SizeOfStackCommit:qword;
                                  SizeOfHeapReserve:qword;
                                  SizeOfHeapCommit:qword;
                                  LoaderFlags:dword;
                                  NumberOfRvaAndSizes:dword;
                                  end;
     Pcoff_optional_image_header64=^coff_optional_image_header64;
     {PE Image Data Directory}
     pe_data_directory=packed record
                       VirtualAddress:Dword;
                       Size:dword;
                       end;
     Ppe_data_directory=^pe_data_directory;
     pe_image_header=packed record
                     signature:array[1..4] of char;
                     ImageHeader:coff_image_header;
                     case Boolean of
                     False:(OptionalHeader32:coff_optional_image_header32;);
                     True:(OptionalHeader64:coff_optional_image_header64;);
                     end;
     Ppe_image_header=^pe_image_header;
     {PE Section Header}
     pe_image_section_header=packed record
                             Name:array[1..8] of char;
                             VirtualSize:dword;
                             VirtualAddress:dword;
                             SizeOfRawData:dword;
                             PointerToRawData:dword;
                             PointerToRelocations:dword;
                             PointerToLineNumbers:dword;
                             NumberOfRelocations:word;
                             NumberOfLineNumbers:word;
                             Characteristics:dword;
                             end;
     Ppe_image_section_header=^pe_image_section_header;
     {PE Relocation Block}
     pe_image_base_relocation_block=packed record
                                    VirtualAddress:dword;
                                    SizeOfBlock:dword;
                                    end;
     Ppe_image_base_relocation_block=^pe_image_base_relocation_block;
     pe_image_base_relocation_item=bitpacked record
                                   Offset:0..4095;
                                   RelocationType:0..15;
                                   end;
     Ppe_image_base_relocation_item=^pe_image_base_relocation_item;
     {Coff Symbol Table}
     coff_symbol_table_name=packed record
                            case Boolean of
                            True:(Name:array[1..8] of char;);
                            False:(Reserved:dword;Offset:dword;);
                            end;
     coff_symbol_table_item=packed record
                            Name:coff_symbol_table_name;
                            Address:dword;
                            SectionNumber:smallint;
                            SymbolType:word;
                            StorageClass:byte;
                            NumberOfAuxSymbols:byte;
                            end;
     Pcoff_symbol_table_item=^coff_symbol_table_item;

      {ELF Magic Number in ELF ID(From Byte 0 to Byte 3)}
const elf_magic:array[1..4] of char=(#$7F,'E','L','F');
      {ELF Class Position in ELF ID}
      elf_class_position:byte=5;
      {ELF Class Value}
      elf_class_none:byte=0;
      elf_class_32:byte=1;
      elf_class_64:byte=2;
      {ELF Data Position in ELF ID}
      elf_data_position:byte=6;
      {ELF Data Value}
      elf_data_none:byte=0;
      elf_data_lsb:byte=1;
      elf_data_msb:byte=2;
      {ELF File Version}
      elf_file_version_position=7;
      elf_file_version_current=1;
      {ELF OS ABI Positon in ELF ID}
      elf_os_abi_position:byte=8;
      {ELF OS ABI Value}
      elf_os_abi_none:byte=0;
      elf_os_abi_system_v:byte=0;
      elf_os_abi_netbsd:byte=2;
      elf_os_abi_gnu:byte=3;
      elf_os_abi_linux:byte=3;
      elf_os_abi_freebsd:byte=9;
      elf_os_abi_openbsd:byte=12;
      elf_os_abi_arm_eabi:byte=13;
      elf_os_abi_arm:byte=14;
      elf_os_abi_standalone:byte=15;
      {ELF ABI Version in ELF ID}
      elf_abi_version_position:byte=9;
      {ELF pad index in ELF ID}
      elf_pad_position:byte=9;
      {ELF File Type Value}
      elf_type_none:word=0;
      elf_type_relocatable:word=1;
      elf_type_executable:word=2;
      elf_type_dynamic:word=3;
      elf_type_core:word=4;
      elf_type_number_of_type:word=5;
      elf_type_os_specific_range_start:word=$FE00;
      elf_type_os_specific_range_end:word=$FEFF;
      elf_type_processor_specific_range_start:word=$FF00;
      elf_type_processor_specific_range_end:word=$FFFF;
      {ELF Machine Value}
      elf_machine_none=0;
      elf_machine_386=3;
      elf_machine_arm=40;
      elf_machine_x86_64=62;
      elf_machine_aarch64=183;
      elf_machine_riscv=243;
      elf_machine_loongarch=258;
      {ELF Version Value}
      elf_version_none:word=0;
      elf_version_current:word=1;
      {ELF Special Section Indices}
      elf_section_header_index_undefined:word=0;
      elf_section_header_reserved_low:word=$FF00;
      elf_section_header_processor_low:word=$FF00;
      elf_section_header_before_all_others:word=$FF00;
      elf_section_header_after_all_others:word=$FF01;
      elf_section_header_processor_high:word=$FF1F;
      elf_section_header_os_low:word=$FF20;
      elf_section_header_os_high:word=$FF3F;
      elf_section_header_associated_symbol_is_absolute:word=$FFF1;
      elf_section_header_associated_symbol_is_common:word=$FFF2;
      elf_section_header_index_is_in_extra_table:word=$FFFF;
      elf_section_header_high_reserved:word=$FFFF;
      {ELF Section Type Value}
      elf_section_type_null:dword=0;
      elf_section_type_progbit:dword=1;
      elf_section_type_symtab:dword=2;
      elf_section_type_strtab:dword=3;
      elf_section_type_rela:dword=4;
      elf_section_type_hash:dword=5;
      elf_section_type_dynamic:dword=6;
      elf_section_type_note:dword=7;
      elf_section_type_nobit:dword=8;
      elf_section_type_reloc:dword=9;
      elf_section_type_reserved:dword=10;
      elf_section_type_dynsym:dword=11;
      elf_section_type_init_array:dword=14;
      elf_section_type_fini_array:dword=15;
      elf_section_type_preinit_array:dword=16;
      elf_section_type_group:dword=17;
      elf_section_type_symtab_section_index:dword=18;
      elf_section_type_relr:dword=19;
      elf_section_type_os_low:dword=$60000000;
      elf_section_type_gnu_attributes:dword=$6FFFFFF5;
      elf_section_type_gnu_hash:dword=$6FFFFFF6;
      elf_section_type_gnu_liblist:dword=$6FFFFFF7;
      elf_section_type_checksum:dword=$6FFFFFF8;
      elf_section_type_gnu_version_define:dword=$6FFFFFFD;
      elf_section_type_gnu_version_need:dword=$6FFFFFFE;
      elf_section_type_gnu_version_symbol:dword=$6FFFFFFF;
      elf_section_type_os_high:dword=$6FFFFFFF;
      elf_section_type_processor_low:dword=$70000000;
      elf_section_type_processor_high:dword=$7FFFFFFF;
      elf_section_type_application_low:dword=$80000000;
      elf_section_type_application_high:dword=$8FFFFFFF;
      {ELF Section Flag Value(can be combined using or)}
      elf_section_flag_write:dword=1;
      elf_section_flag_alloc:dword=1 shl 1;
      elf_section_flag_executable:dword=1 shl 2;
      elf_section_flag_merge:dword=1 shl 4;
      elf_section_flag_strings:dword=1 shl 5;
      elf_section_flag_info_link:dword=1 shl 6;
      elf_section_flag_link_order:dword=1 shl 7;
      elf_section_flag_non_standard_os_specific_handling:dword=1 shl 8;
      elf_section_flag_group:dword=1 shl 9;
      elf_section_flag_tls:dword=1 shl 10;
      elf_section_flag_compressed:dword=1 shl 11;
      elf_section_flag_mask_os:dword=$0FF00000;
      elf_section_flag_mask_processor:dword=$F0000000;
      elf_section_flag_gnu_retain:dword=1 shl 21;
      {ELF Compression Type Value}
      elf_compression_type_zlib:dword=1;
      elf_compression_type_zstandard:dword=2;
      {ELF Section Group Handle Value}
      elf_group_COMDAT:byte=$1;
      {ELF Symbol Info Bound To Value}
      elf_symbol_info_bound_to_self:word=$FFFF;
      elf_symbol_info_bound_to_parent:word=$FFFE;
      elf_symbol_info_bound_to_low_reserved:word=$FF00;
      {ELF Symbol Info Flag Value}
      elf_symbol_info_flag_direct:word=$0001;
      elf_symbol_info_flag_pass_through:word=$0002;
      elf_symbol_info_flag_copy:word=$0004;
      elf_symbol_info_flag_lazy_load:word=$0008;
      {ELF Symbol Info Version Value}
      elf_symbol_info_version_none:byte=0;
      elf_symbol_info_version_current:byte=1;
      {ELF Symbol Type Bind Value}
      elf_symbol_bind_local:byte=0;
      elf_symbol_bind_global:byte=1;
      elf_symbol_bind_weak:byte=2;
      elf_symbol_bind_gnu_unique:byte=10;
      {ELF Symbol Type Type Value}
      elf_symbol_type_no_type:byte=0;
      elf_symbol_type_object:byte=1;
      elf_symbol_type_function:byte=2;
      elf_symbol_type_section:byte=3;
      elf_symbol_type_file:byte=4;
      elf_symbol_type_common:byte=5;
      elf_symbol_type_tls:byte=6;
      elf_symbol_type_os_low:byte=10;
      elf_symbol_type_gnu_indirect_function=11;
      elf_symbol_type_os_high:byte=12;
      elf_symbol_type_processor_low=13;
      elf_symbol_type_processor_high=15;
      {ELF Symbol Type Other Value}
      elf_symbol_other_undefined:word=0;
      elf_symbol_other_absolute:word=$FFF1;
      elf_symbol_other_common:word=$FFF2;
      elf_symbol_other_xindex:word=$FFFF;
      elf_symbol_other_highreserve:word=$FFFF;
      {ELF Symbol Type Visibility Value}
      elf_symbol_visibility_default:byte=0;
      elf_symbol_visibility_internal:byte=1;
      elf_symbol_visibility_hidden:byte=2;
      elf_symbol_visibility_protected:byte=3;
      {ELF Program Header Type Value}
      elf_program_header_type_null:dword=0;
      elf_program_header_type_load:dword=1;
      elf_program_header_type_dynamic:dword=2;
      elf_program_header_type_interp:dword=3;
      elf_program_header_type_note:dword=4;
      elf_program_header_type_self:dword=6;
      elf_program_header_type_tls:dword=7;
      elf_program_header_type_gnu_ehframe:dword=$6474e550;
      elf_program_header_type_gnu_stack:dword=$6474e551;
      elf_program_header_type_gnu_relro:dword=$6474e552;
      elf_program_header_type_gnu_property:dword=$6474e553;
      elf_program_header_type_gnu_sframe:dword=$6474e554;
      elf_program_header_type_processor_low:dword=$70000000;
      elf_program_header_type_processor_high:dword=$7FFFFFFF;
      {ELF Program Header Flag Value}
      elf_program_header_execute:dword=1;
      elf_program_header_write:dword=1 shl 1;
      elf_program_header_alloc:dword=1 shl 2;
      elf_program_header_mask_os:dword=$0FF00000;
      elf_program_header_mask_processor:dword=$F0000000;
      {ELF Note Segment Descriptor Type Value}
      elf_note_prstatus=1;
      elf_note_prfpreg=2;
      elf_note_fpregset=2;
      elf_note_prpsinfo=3;
      elf_note_prxreg=4;
      elf_note_taskstruct=4;
      elf_note_platform=5;
      elf_note_auxv_array=6;
      elf_note_gwindows=7;
      elf_note_asrs=8;
      elf_note_pstatus=10;
      elf_note_psinfo=13;
      elf_note_prcred=14;
      elf_note_utsname=15;
      elf_note_lwpstatus=16;
      elf_note_lwpsinfo=17;
      elf_note_prfpxreg=20;
      elf_note_siginfo=$53494749;
      elf_note_file=$46494C45;
      elf_note_prxfpreg=$46E62B7F;
      elf_note_386_tls=$200;
      elf_note_386_ioperm=$201;
      elf_note_x86_xstate=$202;
      elf_note_x86_shstk=$204;
      elf_note_arm_vfp=$400;
      elf_note_arm_tls=$401;
      elf_note_arm_hw_break=$402;
      elf_note_arm_hw_watch=$403;
      elf_note_arm_syscall=$404;
      elf_note_arm_sve=$405;
      elf_note_arm_pac_mask=$406;
      elf_note_arm_paca_keys=$407;
      elf_note_arm_pacg_keys=$408;
      elf_note_arm_tagged_address_control=$409;
      elf_note_arm_pac_enable_keys=$40A;
      elf_note_arm_ssve=$40B;
      elf_note_arm_za=$40C;
      elf_note_arm_zt=$40D;
      elf_note_arm_fpmr=$40E;
      elf_note_loongarch_cpucfg=$A00;
      elf_note_loongarch_csr=$A01;
      elf_note_loongarch_lsx=$A02;
      elf_note_loongarch_lasx=$A03;
      elf_note_loongarch_lbt=$A04;
      elf_note_loongarch_hardware_break=$A05;
      elf_note_loongarch_hardware_watch=$A06;
      {ELF Note Version}
      elf_note_version=$1;
      {ELF Dynamic Type Value}
      elf_dynamic_type_null=0;
      elf_dynamic_type_needed=1;
      elf_dynamic_type_pltrel_size=2;
      elf_dynamic_type_pltgot=3;
      elf_dynamic_type_hash=4;
      elf_dynamic_type_string_table=5;
      elf_dynamic_type_symbol_table=6;
      elf_dynamic_type_rela=7;
      elf_dynamic_type_rela_size=8;
      elf_dynamic_type_rela_entry=9;
      elf_dynamic_type_String_table_size=10;
      elf_dynamic_type_symbol_table_entry=11;
      elf_dynamic_type_initialization=12;
      elf_dynamic_type_finalization=13;
      elf_dynamic_type_shared_object_name=14;
      elf_dynamic_type_library_search_path=15;
      elf_dynamic_type_symbolic=16;
      elf_dynamic_type_rel=17;
      elf_dynamic_type_rel_size=18;
      elf_dynamic_type_rel_entry=19;
      elf_dynamic_type_plt_rel=20;
      elf_dynamic_type_debug=21;
      elf_dynamic_type_textrel=22;
      elf_dynamic_type_jmprel=23;
      elf_dynamic_type_bind_now=24;
      elf_dynamic_type_initialize_array=25;
      elf_dynamic_type_finalize_array=26;
      elf_dynamic_type_initialize_array_size=27;
      elf_dynamic_type_finalize_array_size=28;
      elf_dynamic_type_run_path=29;
      elf_dynamic_type_flags=30;
      elf_dynamic_type_encoding=32;
      elf_dynamic_type_preinitialize_array=32;
      elf_dynamic_type_preinitialize_array_size=33;
      elf_dynamic_type_symbol_table_string_table=34;
      elf_dynamic_type_relr_size=35;
      elf_dynamic_type_relr=36;
      elf_dynamic_type_relr_entry=37;
      elf_dynamic_type_gnu_prelinked=$6FFFFDF5;
      elf_dynamic_type_conflict_section_size=$6FFFFDF6;
      elf_dynamic_type_library_list_size=$6FFFFDF7;
      elf_dynamic_type_checksum=$6FFFFDF8;
      elf_dynamic_type_pltpad_size=$6FFFFDF9;
      elf_dynamic_type_move_entry=$6FFFFDFA;
      elf_dynamic_type_move_size=$6FFFFDFB;
      elf_dynamic_type_feature=$6FFFFDFC;
      elf_dynamic_type_posflag=$6FFFFDFD;
      elf_dynamic_type_symbol_info_size=$6FFFFDFE;
      elf_dynamic_type_symbol_info_entry=$6FFFFDFF;
      elf_dynamic_type_version_symbol=$6FFFFFF0;
      elf_dynamic_type_rela_count=$6FFFFFF9;
      elf_dynamic_type_rel_count=$6FFFFFFA;
      elf_dynamic_type_os_low=$6000000D;
      elf_dynamic_type_os_high=$6FFFF000;
      elf_dynamic_type_flags_1=$6FFFFFFB;
      elf_dynamic_type_processor_low=$70000000;
      elf_dynamic_type_processor_high=$7FFFFFFF;
      {ELF Dynamic Flags Value(for dynamic_value member) when Dynamic Type is elf_dynamic_type_flags}
      elf_dynamic_flag_origin:dword=1;
      elf_dynamic_flag_symbolic:dword=2;
      elf_dynamic_flag_textrel:dword=4;
      elf_dynamic_flag_bind_now:dword=8;
      elf_dynamic_flag_static_tls:dword=16;
      {ELF Dynamic Flags Value(for dynamic_value member) when Dynamic Type is elf_dynamic_type_posflags}
      elf_dynamic_flag_1_now:dword=1;
      elf_dynamic_flag_1_global:dword=2;
      elf_dynamic_flag_1_group:dword=4;
      elf_dynamic_flag_1_nodelete:dword=8;
      elf_dynamic_flag_1_load_filter:dword=$10;
      elf_dynamic_flag_1_init_first:dword=$20;
      elf_dynamic_flag_1_no_open:dword=$40;
      elf_dynamic_flag_1_origin:dword=$80;
      elf_dynamic_flag_1_direct:dword=$100;
      elf_dynamic_flag_1_trans:dword=$200;
      elf_dynamic_flag_1_interpos:dword=$400;
      elf_dynamic_flag_1_nodeflib:dword=$800;
      elf_dynamic_flag_1_nodump:dword=$1000;
      elf_dynamic_flag_1_configuration_alternative:dword=$2000;
      elf_dynamic_flag_1_end_filter:dword=$4000;
      elf_dynamic_flag_1_disp_reloc_build:dword=$8000;
      elf_dynamic_flag_1_disp_reloc_runtime:dword=$10000;
      elf_dynamic_flag_1_no_direct:dword=$20000;
      elf_dynamic_flag_1_ign_multi_define:dword=$40000;
      elf_dynamic_flag_1_no_k_syms:dword=$80000;
      elf_dynamic_flag_1_no_header:dword=$100000;
      elf_dynamic_flag_1_edited:dword=$200000;
      elf_dynamic_flag_1_no_reloc:dword=$400000;
      elf_dynamic_flag_1_symbol_interposer:dword=$800000;
      elf_dynamic_flag_1_global_audit:dword=$1000000;
      elf_dynamic_flag_1_singleton:dword=$2000000;
      elf_dynamic_flag_1_stub:dword=$4000000;
      elf_dynamic_flag_1_pie:dword=$8000000;
      elf_dynamic_flag_1_kmod:dword=$10000000;
      elf_dynamic_flag_1_weak_filter:dword=$20000000;
      elf_dynamic_flag_1_no_common:dword=$40000000;
      {ELF Dynamic Flag Value(for dynamic_value member) When Dynamic Type is elf_dynamic_type_feature}
      elf_dynamic_feature_parameter_init:dword=$1;
      elf_dynamic_feature_configuration_expression:dword=$2;
      {ELF Version Definition Version Value}
      elf_version_definition_version_none=0;
      elf_version_definition_version_current=1;
      {ELF Version Definition Flag Value}
      elf_version_definition_flag_base=1;
      elf_version_definition_flag_weak=2;
      {ELF Version Definition Index Value}
      elf_version_definition_index_local=0;
      elf_version_definition_index_global=1;
      {ELF Version Needed Value}
      elf_version_needed_none=0;
      elf_version_needed_current=1;
      {ELF Auxiliary Type}
      elf_auxiliary_type_null=0;
      elf_auxiliary_type_ignore=1;
      elf_auxiliary_type_program=2;
      elf_auxiliary_type_program_header=3;
      elf_auxiliary_type_program_header_entry=4;
      elf_auxiliary_type_program_header_number=5;
      elf_auxiliary_type_page_size=6;
      elf_auxiliary_type_base=7;
      elf_auxiliary_type_flags=8;
      elf_auxiliary_type_entry=9;
      elf_auxiliary_type_not_elf=10;
      elf_auxiliary_type_real_uid=11;
      elf_auxiliary_type_effective_uid=12;
      elf_auxiliary_type_real_gid=13;
      elf_auxiliary_type_effective_gid=14;
      elf_auxiliary_type_clock_tick=17;
      elf_auxiliary_type_platform=15;
      elf_auxiliary_type_hardware_capability=16;
      elf_auxiliary_type_fpu_control=18;
      elf_auxiliary_type_data_cache_block_size=19;
      elf_auxiliary_type_instruction_cache_block_size=20;
      elf_auxiliary_type_unified_cache_block_size=21;
      elf_auxiliary_type_hardware_capability_3=29;
      elf_auxiliary_type_hardware_capability_4=30;
      elf_auxiliary_type_execute_filename=31;
      elf_auxiliary_type_system_info=32;
      elf_auxiliary_type_system_info_elf_header=33;
      elf_auxiliary_type_l1i_cache_shape=34;
      elf_auxiliary_type_l1d_cache_shape=35;
      elf_auxiliary_type_l2_cache_shape=36;
      elf_auxiliary_type_l3_cache_shape=37;
      elf_auxiliary_type_l1i_cache_size=40;
      elf_auxiliary_type_l1i_cache_geometry=41;
      elf_auxiliary_type_l1d_cache_size=42;
      elf_auxiliary_type_l1d_cache_geometry=43;
      elf_auxiliary_type_l2_cache_size=44;
      elf_auxiliary_type_l2_cache_geometry=45;
      elf_auxiliary_type_l3_cache_size=46;
      elf_auxiliary_type_l3_cache_geometry=47;
      elf_auxiliary_type_minimum_stack_size=51;
      {ELF Note Value}
      elf_note_solaris:PChar='SUNW Solaris';
      elf_note_gnu:PChar='GNU';
      elf_note_fdo:PChar='FDO';
      elf_note_pagesize_hint=1;
      elf_note_abi=1;
      elf_note_os_linux=0;
      elf_note_os_gnu=1;
      elf_note_os_solaris=2;
      elf_note_os_freebsd=3;
      elf_note_gnu_hardware_capability=2;
      elf_note_gnu_build_id=3;
      elf_note_gnu_gold_version=4;
      elf_note_gnu_property_type_0=5;
      elf_note_fdo_packaging_metadata=$CAFE1A7E;
      elf_note_fdo_dlopen_metadata=$407C0C0A;
      elf_note_gnu_property_section_name:PChar='.note.gnu.property';
      elf_note_gnu_property_stack_size=1;
      elf_note_gnu_property_no_copy_or_protected=2;
      elf_note_gnu_property_uint32_and_lower=$B0000000;
      elf_note_gnu_property_uint32_and_high=$B0007FFF;
      elf_note_gnu_property_uint32_or_lower=$B0008000;
      elf_note_gnu_property_uint32_or_high=$B000FFFF;
      elf_note_gnu_property_1_needed=$B0008000;
      elf_note_gnu_property_1_needed_indirect_extern_access=1;
      elf_note_gnu_property_processor_low=$C0000000;
      elf_note_gnu_property_processor_high=$DFFFFFFF;
      elf_note_gnu_property_user_low=$E0000000;
      elf_note_gnu_property_user_high=$FFFFFFFF;
      elf_note_gnu_property_aarch64_feature_1_and=$C0000000;
      elf_note_gnu_property_aarch64_feature_1_bti=1;
      elf_note_gnu_property_aarch64_feature_1_pac=1 shl 1;
      elf_note_gnu_property_x86_isa_1_used=$C0010002;
      elf_note_gnu_property_x86_isa_1_needed=$C0080002;
      elf_note_gnu_property_x86_feature_1_and=$C0000002;
      elf_note_gnu_property_x86_isa_1_baseline=1;
      elf_note_gnu_property_x86_isa_1_v2=2;
      elf_note_gnu_property_x86_isa_1_v3=4;
      elf_note_gnu_property_x86_ias_1_v4=8;
      elf_note_gnu_property_x86_feature_1_ibt=1;
      elf_note_gnu_property_x86_feature_1_shstk=2;
      {ELF i386 relocations}
      elf_reloc_i386_none=0;
      elf_reloc_i386_32bit=1;
      elf_reloc_i386_pc32=2;
      elf_reloc_i386_got32=3;
      elf_reloc_i386_plt32=4;
      elf_reloc_i386_copy=5;
      elf_reloc_i386_new_got_entry=6;
      elf_reloc_i386_new_plt_entry=7;
      elf_reloc_i386_relative=8;
      elf_reloc_i386_got_offset=9;
      elf_reloc_i386_32bit_pc_relative_offset=10;
      elf_reloc_i386_32plt=11;
      elf_reloc_i386_offset_in_static_tls_block=14;
      elf_reloc_i386_address_of_got_entry_for_static_tls_block_offset=15;
      elf_reloc_i386_got_entry_for_static_tls_block_offset=16;
      elf_reloc_i386_offset_relative_to_static_tls_block=17;
      elf_reloc_i386_general_dynamic_thread=18;
      elf_reloc_i386_local_dynamic_thread=19;
      elf_reloc_i386_16bit=20;
      elf_reloc_i386_pc16bit=21;
      elf_reloc_i386_8bit=22;
      elf_reloc_i386_pc8bit=23;
      elf_reloc_i386_tls_general_dynamic_thread_32bit=24;
      elf_reloc_i386_tls_general_dynamic_thread_pushl=25;
      elf_reloc_i386_tls_general_dynamic_thread_call_for_tls_get_addr=26;
      elf_reloc_i386_tls_general_dynamic_thread_popl=27;
      elf_reloc_i386_tls_local_dynamic_thread_32bit=28;
      elf_reloc_i386_tls_local_dynamic_thread_push1=29;
      elf_reloc_i386_tls_local_dynamic_thread_call_for_tls_get_addr=30;
      elf_reloc_i386_tls_local_dynamic_thread_popl=31;
      elf_reloc_i386_offset_relative_for_tls_block=32;
      elf_reloc_i386_ie_32bit=33;
      elf_reloc_i386_le_32bit=34;
      elf_reloc_i386_tls_module_containing_symbol=35;
      elf_reloc_i386_tls_offset_in_tls_block=36;
      elf_reloc_i386_tls_negated_offset=37;
      elf_reloc_i386_size32=38;
      elf_reloc_i386_tls_got_offset_for_tls_descriptor=39;
      elf_reloc_i386_tls_descriptor_call=40;
      elf_reloc_i386_tls_descriptor=41;
      elf_reloc_i386_indirect_relative=42;
      elf_reloc_i386_got_relaxable=43;
      {ELF ARM flags for elf_flags in ELF header}
      elf_flags_arm_relaxed:dword=1;
      elf_flags_arm_hasentry:dword=1 shl 1;
      elf_flags_arm_interwork:dword=1 shl 2;
      elf_flags_arm_apcs_26:dword=1 shl 3;
      elf_flags_arm_apcs_float:dword=1 shl 4;
      elf_flags_arm_pic:dword=1 shl 5;
      elf_flags_arm_align8:dword=1 shl 6;
      elf_flags_arm_new_abi:dword=1 shl 7;
      elf_flags_arm_old_abi:dword=1 shl 8;
      elf_flags_arm_soft_float:dword=1 shl 9;
      elf_flags_arm_vfp_float:dword=1 shl 10;
      elf_flags_arm_maverick_float:dword=1 shl 11;
      elf_flags_arm_abi_float_soft:dword=1 shl 9;
      elf_flags_arm_abi_float_hard:dword=1 shl 10;
      elf_flags_arm_symbols_are_sorted:dword=1 shl 2;
      elf_flags_arm_dynamic_symbols_uses_segment_index=1 shl 3;
      elf_flags_arm_map_symbols_first:dword=1 shl 4;
      elf_flags_arm_eabi_mask:dword=$FF000000;
      elf_flags_arm_big_endian_8:dword=$00800000;
      elf_flags_arm_little_endian_8:dword=$00400000;
      elf_flags_arm_eabi_unknown:dword=$0;
      elf_flags_arm_eabi_version_1:dword=$1000000;
      elf_flags_arm_eabi_version_2:dword=$2000000;
      elf_flags_arm_eabi_version_3:dword=$3000000;
      elf_flags_arm_eabi_version_4:dword=$4000000;
      elf_flags_arm_eabi_version_5:dword=$5000000;
      {ELF ARM Additional Symbol Types}
      elf_symbol_type_arm_thumb_function:dword=elf_symbol_type_processor_low;
      elf_symbol_type_arm_16bit:dword=elf_symbol_type_processor_high;
      {ELF ARM Additional Section Header Flags}
      elf_section_header_flag_arm_entry_section:dword=$10000000;
      elf_section_header_flag_arm_multiple_definition:dword=$80000000;
      {ELF ARM Additional Program Header Flags}
      elf_program_header_flag_arm_static_base:dword=$10000000;
      elf_program_header_flag_arm_position_independent:dword=$20000000;
      elf_program_header_flag_arm_absolute:dword=$40000000;
      {ELF ARM Additional Program Header Type}
      elf_program_header_type_arm_unwind:dword=$70000001;
      {ELF ARM Additional Section Header Type}
      elf_section_header_type_arm_contains_entry_point:dword=$70000001;
      elf_section_header_type_arm_preempt_map:dword=$70000002;
      elf_section_header_type_arm_attributes:dword=$70000003;
      {ELF AArch64 Relocations}
      elf_reloc_aarch64_none=0;
      elf_reloc_aarch64_32bit_absolute=1;
      elf_reloc_aarch64_32bit_copy=180;
      elf_reloc_aarch64_32bit_new_got_entry=181;
      elf_reloc_aarch64_32bit_new_plt_entry=182;
      elf_reloc_aarch64_32bit_relative=183;
      elf_reloc_aarch64_32bit_tls_module_number=184;
      elf_reloc_aarch64_32bit_tls_module_relative_offset=185;
      elf_reloc_aarch64_32bit_tls_tp_relative_offset=186;
      elf_reloc_aarch64_32bit_tls_descriptor=187;
      elf_reloc_aarch64_32bit_indirect_relative=188;
      elf_reloc_aarch64_absolute_64bit=257;
      elf_reloc_aarch64_absolute_32bit=258;
      elf_reloc_aarch64_absolute_16bit=259;
      elf_reloc_aarch64_absolute_pc_relative_64bit=260;
      elf_reloc_aarch64_absolute_pc_relative_32bit=261;
      elf_reloc_aarch64_absolute_pc_relative_16bit=262;
      elf_reloc_aarch64_movz_imm_bit15_0=263;
      elf_reloc_aarch64_movk_imm_bit15_0=264;
      elf_reloc_aarch64_movz_imm_bit31_16=265;
      elf_reloc_aarch64_movk_imm_bit31_16=266;
      elf_reloc_aarch64_movz_imm_bit47_32=267;
      elf_reloc_aarch64_movk_imm_bit47_32=268;
      elf_reloc_aarch64_movk_z_imm_bit64_48=269;
      elf_reloc_aarch64_movn_z_imm_bit15_0=270;
      elf_reloc_aarch64_movn_z_imm_bit31_16=271;
      elf_reloc_aarch64_movn_z_imm_bit47_32=272;
      elf_reloc_aarch64_ldr_literal_pc_rel_low19bit=273;
      elf_reloc_aarch64_adr_pc_rel_low21bit=274;
      elf_reloc_aarch64_adrp_page_rel_bit32_12=275;
      elf_reloc_aarch64_adrp_page_rel_bit32_12_no_check=276;
      elf_reloc_aarch64_add_absolute_low12bit=277;
      elf_reloc_aarch64_ld_or_st_absolute_low12bit=278;
      elf_reloc_aarch64_pc_rel_tbz_bit15_2=279;
      elf_reloc_aarch64_pc_rel_cond_or_br_bit20_2=280;
      elf_reloc_aarch64_pc_rel_jump_bit27_2=282;
      elf_reloc_aarch64_pc_rel_call_bit27_2=283;
      elf_reloc_aarch64_add_bit16_imm_bit11_1=284;
      elf_reloc_aarch64_add_bit32_imm_bit11_2=285;
      elf_reloc_aarch64_add_bit64_imm_bit11_3=286;
      elf_reloc_aarch64_pc_rel_movn_z_imm_bit15_0=287;
      elf_reloc_aarch64_pc_rel_movk_imm_bit15_0=288;
      elf_reloc_aarch64_pc_rel_movn_z_imm_bit31_16=289;
      elf_reloc_aarch64_pc_rel_movk_imm_bit31_16=290;
      elf_reloc_aarch64_pc_rel_movn_z_imm_bit47_32=291;
      elf_reloc_aarch64_pc_rel_movk_imm_bit47_32=292;
      elf_reloc_aarch64_pc_rel_movn_z_imm_bit63_48=293;
      elf_reloc_aarch64_add_bit128_imm_from_bit11_4=299;
      elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit15_0=300;
      elf_reloc_aarch64_got_rel_offset_movk_imm_bit15_0=301;
      elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit31_16=302;
      elf_reloc_aarch64_got_rel_offset_movk_imm_bit31_16=303;
      elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit47_32=304;
      elf_reloc_aarch64_got_rel_offset_movk_imm_bit47_32=305;
      elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit63_48=306;
      elf_reloc_aarch64_got_relative_64bit=307;
      elf_reloc_aarch64_got_relative_32bit=308;
      elf_reloc_aarch64_pc_rel_got_offset=309;
      elf_reloc_aarch64_got_rel_offset_ld_st_imm_bit14_3=310;
      elf_reloc_aarch64_page_rel_adrp_bit32_12=311;
      elf_reloc_aarch64_dir_got_offset_ld_st_imm_bit11_3=312;
      elf_reloc_aarch64_got_page_rel_got_offset_ld_st_bit14_3=313;
      elf_reloc_aarch64_plt_32=314;
      elf_reloc_aarch64_pc_relative_got_offset32=315;
      elf_reloc_aarch64_pc_relative_adr_imm_bit20_0=512;
      elf_reloc_aarch64_page_relative_adr_imm_bit32_12=513;
      elf_reloc_aarch64_direct_add_imm_bit11_0=514;
      elf_reloc_aarch64_got_rel_movn_z_bit31_16=515;
      elf_reloc_aarch64_got_rel_movk_imm_bit15_0=516;
      elf_reloc_aarch64_adr_pc_relative_21bit=517;
      elf_reloc_aarch64_adr_page_relative_21bit=518;
      elf_reloc_aarch64_direct_add_low_bit11_0=519;
      elf_reloc_aarch64_got_rel_movn_z_bit31_16_local_dynamic_model=520;
      elf_reloc_aarch64_got_rel_movk_imm_bit15_0_local_dynamic_model=521;
      elf_reloc_aarch64_tls_pc_relative=522;
      elf_reloc_aarch64_tls_dtp_rel_movn_z_bit47_32=523;
      elf_reloc_aarch64_tls_dtp_rel_movn_z_bit31_16=524;
      elf_reloc_aarch64_tls_dtp_rel_movk_bit31_16=525;
      elf_reloc_aarch64_tls_dtp_rel_movn_z_bit15_0=526;
      elf_reloc_aarch64_tls_dtp_rel_movk_bit15_0=527;
      elf_reloc_aarch64_tls_dtp_rel_add_imm_bit23_12=528;
      elf_reloc_aarch64_tls_dtp_rel_add_imm_bit11_0=529;
      elf_reloc_aarch64_tls_dtp_rel_add_imm_no_check=530;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_0=531;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_0_no_check=532;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_1=533;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_1_no_check=534;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_2=535;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_2_no_check=536;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_3=537;
      elf_reloc_aarch64_tls_dtp_rel_ld_sd_imm_bit11_3_no_check=538;
      elf_reloc_aarch64_tls_got_rel_movn_z_bit31_16=539;
      elf_reloc_aarch64_tls_got_rel_movk_bit15_0=540;
      elf_reloc_aarch64_tls_page_rel_adrp_bit32_12=541;
      elf_reloc_aarch64_tls_direct_ld_off_bit11_3=542;
      elf_reloc_aarch64_tls_pc_rel_load_imm=543;
      elf_reloc_aarch64_tls_tp_rel_movn_z_bit47_32=544;
      elf_reloc_aarch64_tls_tp_rel_movn_z_bit31_16=545;
      elf_reloc_aarch64_tls_tp_rel_movk_bit31_16=546;
      elf_reloc_aarch64_tls_tp_rel_movn_z_bit15_0=547;
      elf_reloc_aarch64_tls_tp_rel_movk_bit15_0=548;
      elf_reloc_aarch64_tls_tp_rel_add_imm_bit23_12=549;
      elf_reloc_aarch64_tls_tp_rel_add_imm_bit11_0=550;
      elf_reloc_aarch64_tls_tp_rel_add_no_overflow=551;
      elf_reloc_aarch64_tls_tp_rel_ld_st_off_bit11_0=552;
      elf_reloc_aarch64_tls_tp_rel_ld_st_bit11_0_no_overflow=553;
      elf_reloc_aarch64_tls_tp_rel_ld_st_off_bit11_1=554;
      elf_reloc_aarch64_tls_tp_rel_ld_st_bit11_1_no_overflow=555;
      elf_reloc_aarch64_tls_tp_rel_ld_st_off_bit11_2=556;
      elf_reloc_aarch64_tls_tp_rel_ld_st_bit11_2_no_overflow=557;
      elf_reloc_aarch64_tls_tp_rel_ld_st_off_bit11_3=558;
      elf_reloc_aarch64_tls_tp_rel_ld_st_bit11_3_no_overflow=559;
      elf_reloc_aarch64_tls_pc_rel_ld_bit20_2=560;
      elf_reloc_aarch64_tls_pc_rel_adr_bit20_0=561;
      elf_reloc_aarch64_tls_page_rel_adr_imm_bit32_12=562;
      elf_reloc_aarch64_tls_descriptor_direct_ld_off_bit11_3=563;
      elf_reloc_aarch64_tls_descriptor_direct_add_off_bit11_0=564;
      elf_reloc_aarch64_tls_descriptor_got_rel_movn_z_bit31_16=565;
      elf_reloc_aarch64_tls_descriptor_got_rel_movk_bit15_0=566;
      elf_reloc_aarch64_tls_relax_ldr=567;
      elf_reloc_aarch64_tls_relax_add=568;
      elf_reloc_aarch64_tls_relax_blr=569;
      elf_reloc_aarch64_tls_tp_rel_ld_st_offset=570;
      elf_reloc_aarch64_tls_tp_rel_ld_st_offset_no_check=571;
      elf_reloc_aarch64_tls_dtp_rel_ld_st_imm=572;
      elf_reloc_aarch64_tls_dtp_rel_ld_st_imm_no_check=573;
      elf_reloc_aarch64_copy=1024;
      elf_reloc_aarch64_new_global_entry=1025;
      elf_reloc_aarch64_new_plt_entry=1026;
      elf_reloc_aarch64_relative=1027;
      elf_reloc_aarch64_tls_dtp_module=1028;
      elf_reloc_aarch64_tls_dtp_relocate=1029;
      elf_reloc_aarch64_tls_tp_relative_offset=1030;
      elf_reloc_aarch64_tls_descriptor=1031;
      elf_reloc_aarch64_indirect_relative=1032;
      {ELF AArch64 Program Header Type}
      elf_program_header_type_aarch64_memory_tag_mte:dword=$70000001;
      {ELF AArch64 Dynamic Tag}
      elf_dynamic_tag_aarch64_bti_plt:dword=$70000001;
      elf_dynamic_tag_aarch64_pac_plt:dword=$70000003;
      elf_dynamic_tag_aarch64_variant_pcs:dword=$70000005;
      {ELF AArch64 Symbol Table Other Value}
      elf_symbol_table_other_aarch64_variant_pcs:byte=$80;
      {ELF ARM Relocations}
      elf_reloc_arm_none=0;
      elf_reloc_arm_pc_relative_26bit_branch=1;
      elf_reloc_arm_absolute_32bit=2;
      elf_reloc_arm_pc_relative_32bit=3;
      elf_reloc_arm_pc_relative_13bit_branch=4;
      elf_reloc_arm_absolute_16bit=5;
      elf_reloc_arm_absolute_12bit=6;
      elf_reloc_arm_thumb_absolute_5bit=7;
      elf_reloc_arm_absolute_8bit=8;
      elf_reloc_arm_sb_reloc_32bit=9;
      elf_reloc_arm_thumb_pc_22bit=10;
      elf_reloc_arm_thumb_pc_8bit=11;
      elf_reloc_arm_amp_vcall_9bit=12;
      elf_reloc_arm_swi24=13;
      elf_reloc_arm_tls_descriptor=13;
      elf_reloc_arm_thumb_swi8=14;
      elf_reloc_arm_xpc25=15;
      elf_reloc_arm_thumb_xpc22=16;
      elf_reloc_arm_tls_dtp_module=17;
      elf_reloc_arm_tls_dtp_offset=18;
      elf_reloc_arm_tls_tp_offset=19;
      elf_reloc_arm_copy=20;
      elf_reloc_arm_new_got_entry=21;
      elf_reloc_arm_new_plt_entry=22;
      elf_reloc_arm_relative=23;
      elf_reloc_arm_got_offset=24;
      elf_reloc_arm_pc_relative_got_offset=25;
      elf_reloc_arm_got_entry_32bit=26;
      elf_reloc_arm_plt_address_32bit=27;
      elf_reloc_arm_call=28;
      elf_reloc_arm_pc_relative_24bit=29;
      elf_reloc_arm_thumb_pc_relative_24bit=30;
      elf_reloc_arm_base_absolute=31;
      elf_reloc_arm_alu_pcrel_bit7_0=32;
      elf_reloc_arm_alu_pcrel_bit15_8=33;
      elf_reloc_arm_alu_pcrel_bit23_16=34;
      elf_reloc_arm_ldr_sbrel_bit11_0=35;
      elf_reloc_arm_alu_sbrel_bit19_12=36;
      elf_reloc_arm_alu_sbrel_bit27_20=37;
      elf_reloc_arm_target1=38;
      elf_reloc_arm_program_base_relative=39;
      elf_reloc_arm_v4bx=40;
      elf_reloc_arm_target2=41;
      elf_reloc_arm_31bit_pc_relative=42;
      elf_reloc_arm_movw_absolute_16bit=43;
      elf_reloc_arm_movt_absolute=44;
      elf_reloc_arm_movw_pc_relative=45;
      elf_reloc_arm_movt_pc_relative=46;
      elf_reloc_arm_thumb_movw_absolute=47;
      elf_reloc_arm_thumb_movt_absolute=48;
      elf_reloc_arm_thumb_movw_pc_relative=49;
      elf_reloc_arm_thumb_movt_pc_relative=50;
      elf_reloc_arm_thumb_pc_relative_20bit_b=51;
      elf_reloc_arm_thumb_pc_relative_6bit_b=52;
      elf_reloc_arm_thumb_alu_pc_relative_bit11_0=53;
      elf_reloc_arm_thumb_pc_12bit=54;
      elf_reloc_arm_absolute_32bit_no_interrupt=55;
      elf_reloc_arm_pc_relative_32bit_no_interrupt=56;
      elf_reloc_arm_alu_pc_relative_g0_no_check=57;
      elf_reloc_arm_alu_pc_relative_g0=58;
      elf_reloc_arm_alu_pc_relative_g1_no_check=59;
      elf_reloc_arm_alu_pc_relative_g1=60;
      elf_reloc_arm_alu_pc_relative_g2=61;
      elf_reloc_arm_ldr_str_ldrb_strb_pc_relative_g1=62;
      elf_reloc_arm_ldr_str_ldrb_strb_pc_relative_g2=63;
      elf_reloc_arm_ldr_str_pc_relative_g0=64;
      elf_reloc_arm_ldr_str_pc_relative_g1=65;
      elf_reloc_arm_ldr_str_pc_relative_g2=66;
      elf_reloc_arm_ldc_stc_pc_relative_g0=67;
      elf_reloc_arm_ldc_stc_pc_relative_g1=68;
      elf_reloc_arm_ldc_stc_pc_relative_g2=69;
      elf_reloc_arm_alu_program_base_relative_add_sub_g0_no_check=70;
      elf_reloc_arm_alu_program_base_relative_add_sub_g0=71;
      elf_reloc_arm_alu_program_base_relative_add_sub_g1_no_check=72;
      elf_reloc_arm_alu_program_base_relative_add_sub_g1=73;
      elf_reloc_arm_alu_program_base_relative_add_sub_g2=74;
      elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g0=75;
      elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g1=76;
      elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g2=77;
      elf_reloc_arm_program_base_relative_ldrs_g0=78;
      elf_reloc_arm_program_base_relative_ldrs_g1=79;
      elf_reloc_arm_program_base_relative_ldrs_g2=80;
      elf_reloc_arm_ldc_base_relative_g0=81;
      elf_reloc_arm_ldc_base_relative_g1=82;
      elf_reloc_arm_ldc_base_relative_g2=83;
      elf_reloc_arm_movw_base_relative_no_check=84;
      elf_reloc_arm_movt_base_relative=85;
      elf_reloc_arm_movw_base_relative=86;
      elf_reloc_arm_thumb_movw_base_relative_no_check=87;
      elf_reloc_arm_thumb_movt_base_relative=88;
      elf_reloc_arm_thumb_movw_base_relative=89;
      elf_reloc_arm_tls_got_descriptor=90;
      elf_reloc_arm_tls_call=91;
      elf_reloc_arm_tls_descriptor_segment=92;
      elf_reloc_arm_thumb_tls_call=93;
      elf_reloc_arm_absolute_plt32=94;
      elf_reloc_arm_got_absolute=95;
      elf_reloc_arm_got_pc_relative=96;
      elf_reloc_arm_got_relative_to_got_origin=97;
      elf_reloc_arm_got_offset_12bit=98;
      elf_reloc_arm_got_relax=99;
      elf_reloc_arm_gnu_vt_entry=100;
      elf_reloc_arm_gnu_vt_inherit=101;
      elf_reloc_arm_thumb_pc_11bit=102;
      elf_reloc_arm_thumb_pc_9bit=103;
      elf_reloc_arm_tls_global_dynamic_32bit=104;
      elf_reloc_arm_tls_local_dynamic_32bit=105;
      elf_reloc_arm_tls_local_dynamic_offset_32bit=106;
      elf_reloc_arm_tls_ie32=107;
      elf_reloc_arm_tls_le32=108;
      elf_reloc_arm_tls_ldo12=109;
      elf_reloc_arm_tls_le12=110;
      elf_reloc_arm_tls_ie12gp=111;
      elf_reloc_arm_me_too=128;
      elf_reloc_arm_thumb_tls_descriptor_segment12=129;
      elf_reloc_arm_thumb_tls_descriptor_segment16=129;
      elf_reloc_arm_thumb_tls_descriptor_segment32=130;
      elf_reloc_arm_thumb_got_entry_relative_to_got_origin=131;
      elf_reloc_arm_thumb_alu_abs_g0_no_check=132;
      elf_reloc_arm_thumb_alu_abs_g1_no_check=133;
      elf_reloc_arm_thumb_alu_abs_g2_no_check=134;
      elf_reloc_arm_thumb_alu_abs_g3=135;
      elf_reloc_arm_thumb_bf16=136;
      elf_reloc_arm_thumb_bf12=137;
      elf_reloc_arm_thumb_bf18=138;
      elf_reloc_arm_indirect_relative=160;
      elf_reloc_arm_rxpc25=249;
      elf_reloc_arm_rsb_relocation_32bit=250;
      elf_reloc_arm_thumb_rpc_32bit=251;
      elf_reloc_arm_relative_relocation_32bit=252;
      elf_reloc_arm_relative_absolute_22bit=253;
      elf_reloc_arm_relative_pc_24bit=254;
      elf_reloc_arm_relative_base=255;
      {ELF x86_64 relocations}
      elf_reloc_x86_64_none=0;
      elf_reloc_x86_64_64bit=1;
      elf_reloc_x86_64_pc_32bit=2;
      elf_reloc_x86_64_got_32bit=3;
      elf_reloc_x86_64_plt_32bit=4;
      elf_reloc_x86_64_copy=5;
      elf_reloc_x86_64_new_got_entry=6;
      elf_reloc_x86_64_new_plt_entry=7;
      elf_reloc_x86_64_relative=8;
      elf_reloc_x86_64_pc_relative_offset_got=9;
      elf_reloc_x86_64_32bit=10;
      elf_reloc_x86_64_32bit_sign=11;
      elf_reloc_x86_64_16bit=12;
      elf_reloc_x86_64_pc_16bit=13;
      elf_reloc_x86_64_8bit=14;
      elf_reloc_x86_64_pc_8bit=15;
      elf_reloc_x86_64_dtp_module_64bit=16;
      elf_reloc_x86_64_dtp_offset_64bit=17;
      elf_reloc_x86_64_tp_offset_64bit=18;
      elf_reloc_x86_64_tls_global_dynamic=19;
      elf_reloc_x86_64_tls_local_dynamic=20;
      elf_reloc_x86_64_dtp_offset_32bit=21;
      elf_reloc_x86_64_got_tp_offset=22;
      elf_reloc_x86_64_tp_offset32=23;
      elf_reloc_x86_64_pc64=24;
      elf_reloc_x86_64_got_offset64=25;
      elf_reloc_x86_64_got_pc32=26;
      elf_reloc_x86_64_got64=27;
      elf_reloc_x86_64_got_pc_relative=28;
      elf_reloc_x86_64_got_pc64=29;
      elf_reloc_x86_64_got_plt64=30;
      elf_reloc_x86_64_plt_offset64=31;
      elf_reloc_x86_64_size32=32;
      elf_reloc_x86_64_size64=33;
      elf_reloc_x86_64_got_pc32_tls_descriptor=34;
      elf_reloc_x86_64_tls_descriptor_call=35;
      elf_reloc_x86_64_tls_descriptor=36;
      elf_reloc_x86_64_indirect_relative=37;
      elf_reloc_x86_64_relative_64=38;
      elf_reloc_x86_64_got_pc_rel=41;
      elf_reloc_x86_64_rex_got_pc_rel=42;
      {ELF x86-64 Section Header Type Value}
      elf_section_type_x86_64_unwind=0;
      {ELF x86-64 Dynamic Tag Value}
      elf_dynamic_tag_x86_64_plt=$70000001;
      elf_dynamic_tag_x86_64_plt_size=$70000002;
      elf_dynamic_tag_x86_64_plt_entry=$70000003;
      {ELF RISC-V ELF Flags}
      elf_flags_riscv_rvc=$0001;
      elf_flags_riscv_float_abi=$0006;
      elf_flags_riscv_float_abi_soft=$0000;
      elf_flags_riscv_float_abi_single=$0002;
      elf_flags_riscv_float_abi_double=$0004;
      elf_flags_riscv_float_abi_quad=$0006;
      elf_flags_riscv_rve=$0008;
      elf_flags_riscv_tso=$0010;
      {ELF RISC-V relocations}
      elf_reloc_riscv_none=0;
      elf_reloc_riscv_32bit=1;
      elf_reloc_riscv_64bit=2;
      elf_reloc_riscv_relative=3;
      elf_reloc_riscv_copy=4;
      elf_reloc_riscv_jump_slot=5;
      elf_reloc_riscv_tls_dtp_module32=6;
      elf_reloc_riscv_tls_dtp_module64=7;
      elf_reloc_riscv_tls_dtp_relative32=8;
      elf_reloc_riscv_tls_dtp_relative64=9;
      elf_reloc_riscv_tls_tp_relative32=10;
      elf_reloc_riscv_tls_tp_relative64=11;
      elf_reloc_riscv_branch=16;
      elf_reloc_riscv_jal=17;
      elf_reloc_riscv_call=18;
      elf_reloc_riscv_call_plt=19;
      elf_reloc_riscv_got_high_20bit=20;
      elf_reloc_riscv_tls_got_high_20bit=21;
      elf_reloc_riscv_tls_global_descriptor_high_20bit=22;
      elf_reloc_riscv_pc_relative_high_20bit=23;
      elf_reloc_riscv_pc_relative_low_12bit=24;
      elf_reloc_riscv_pc_relative_low_12bit_store=25;
      elf_reloc_riscv_high_20bit=26;
      elf_reloc_riscv_low_12bit=27;
      elf_reloc_riscv_low_12bit_store=28;
      elf_reloc_riscv_tp_relative_high_20bit=29;
      elf_reloc_riscv_tp_relative_low_12bit=30;
      elf_reloc_riscv_tp_relative_low_12bit_store=31;
      elf_reloc_riscv_tp_relative_add=32;
      elf_reloc_riscv_add_8bit=33;
      elf_reloc_riscv_add_16bit=34;
      elf_reloc_riscv_add_32bit=35;
      elf_reloc_riscv_add_64bit=36;
      elf_reloc_riscv_sub_8bit=37;
      elf_reloc_riscv_sub_16bit=38;
      elf_reloc_riscv_sub_32bit=39;
      elf_reloc_riscv_sub_64bit=40;
      elf_reloc_riscv_got_32_pc_relative=41;
      elf_reloc_riscv_align=43;
      elf_reloc_riscv_rvc_branch=44;
      elf_reloc_riscv_rvc_jump=45;
      elf_reloc_riscv_relax=51;
      elf_reloc_riscv_sub_6=52;
      elf_reloc_riscv_set_6=53;
      elf_reloc_riscv_set_8=54;
      elf_reloc_riscv_set_16=55;
      elf_reloc_riscv_set_32=56;
      elf_reloc_riscv_32_pcrel=57;
      elf_reloc_riscv_indirect_relative=58;
      elf_reloc_riscv_plt_32bit=59;
      elf_reloc_riscv_set_uleb128=60;
      elf_reloc_riscv_sub_uleb128=61;
      elf_reloc_riscv_tls_descriptor_high_20bit=62;
      elf_reloc_riscv_tls_descriptor_load_low_12bit=63;
      elf_reloc_riscv_tls_descriptor_add_low_12bit=64;
      elf_reloc_riscv_tls_descriptor_call=65;
      {ELF LoongArch ELF Flags}
      elf_flags_loongarch_modifier_mask=$07;
      elf_flags_loongarch_soft_float=$01;
      elf_flags_loongarch_single_float=$02;
      elf_flags_loongarch_double_float=$03;
      elf_flags_loongarch_object_abi_v1=$40;
      {ELF LoongArch relocations}
      elf_reloc_loongarch_none=0;
      elf_reloc_loongarch_32bit=1;
      elf_reloc_loongarch_64bit=2;
      elf_reloc_loongarch_relative=3;
      elf_reloc_loongarch_copy=4;
      elf_reloc_loongarch_jump_slot=5;
      elf_reloc_loongarch_tls_dtp_module_32bit=6;
      elf_reloc_loongarch_tls_dtp_module_64bit=7;
      elf_reloc_loongarch_tls_dtp_relative_32bit=8;
      elf_reloc_loongarch_tls_dtp_relative_64bit=9;
      elf_reloc_loongarch_tls_tp_relative_32bit=10;
      elf_reloc_loongarch_tls_tp_relative_64bit=11;
      elf_reloc_loongarch_indirect_relative=12;
      elf_reloc_loongarch_tls_descriptor_32bit=13;
      elf_reloc_loongarch_tls_descriptor_64bit=14;
      elf_reloc_loongarch_mark_loongarch=20;
      elf_reloc_loongarch_mark_pc_relative=21;
      elf_reloc_loongarch_sop_push_pc_relative=22;
      elf_reloc_loongarch_sop_push_absolute=23;
      elf_reloc_loongarch_sop_push_duplicate=24;
      elf_reloc_loongarch_sop_push_gp_relative=25;
      elf_reloc_loongarch_sop_push_tls_tp_relative=26;
      elf_reloc_loongarch_sop_push_tls_got=27;
      elf_reloc_loongarch_sop_push_tls_global_dynamic=28;
      elf_reloc_loongarch_sop_push_plt_pc_relative=29;
      elf_reloc_loongarch_sop_assert=30;
      elf_reloc_loongarch_sop_not=31;
      elf_reloc_loongarch_sop_sub=32;
      elf_reloc_loongarch_sop_sl=33;
      elf_reloc_loongarch_sop_sr=34;
      elf_reloc_loongarch_sop_add=35;
      elf_reloc_loongarch_sop_and=36;
      elf_reloc_loongarch_sop_if_else=37;
      elf_reloc_loongarch_sop_pop_32_s_10_5=38;
      elf_reloc_loongarch_sop_pop_32_u_10_12=39;
      elf_reloc_loongarch_sop_pop_32_s_10_12=40;
      elf_reloc_loongarch_sop_pop_32_s_10_16=41;
      elf_reloc_loongarch_sop_pop_32_s_10_16_s2=42;
      elf_reloc_loongarch_sop_pop_32_s_5_20=43;
      elf_reloc_loongarch_sop_pop_32_s_0_5_10_16_s2=44;
      elf_reloc_loongarch_sop_pop_32_s_0_10_10_16_s2=45;
      elf_reloc_loongarch_sop_pop_32_u=46;
      elf_reloc_loongarch_add_8bit=47;
      elf_reloc_loongarch_add_16bit=48;
      elf_reloc_loongarch_add_24bit=49;
      elf_reloc_loongarch_add_32bit=50;
      elf_reloc_loongarch_add_64bit=51;
      elf_reloc_loongarch_sub_8bit=52;
      elf_reloc_loongarch_sub_16bit=53;
      elf_reloc_loongarch_sub_24bit=54;
      elf_reloc_loongarch_sub_32bit=55;
      elf_reloc_loongarch_sub_64bit=56;
      elf_reloc_loongarch_gnu_vt_inherit=57;
      elf_reloc_loongarch_gnu_vt_entry=58;
      elf_reloc_loongarch_b16=64;
      elf_reloc_loongarch_b21=65;
      elf_reloc_loongarch_b26=66;
      elf_reloc_loongarch_absolute_high_20bit=67;
      elf_reloc_loongarch_absolute_low_12bit=68;
      elf_reloc_loongarch_absolute_64bit_low_20bit=69;
      elf_reloc_loongarch_absolute_64bit_high_12bit=70;
      elf_reloc_loongarch_absolute_pcala_high_20bit=71;
      elf_reloc_loongarch_absolute_pcala_low_12bit=72;
      elf_reloc_loongarch_absolute_pcala64_low_20bit=73;
      elf_reloc_loongarch_absolute_pcala64_high_12bit=74;
      elf_reloc_loongarch_got_pc_high_20bit=75;
      elf_reloc_loongarch_got_pc_low_12bit=76;
      elf_reloc_loongarch_got64_pc_low_20bit=77;
      elf_reloc_loongarch_got64_pc_high_12bit=78;
      elf_reloc_loongarch_got_high_20bit=79;
      elf_reloc_loongarch_got_low_12bit=80;
      elf_reloc_loongarch_got64_low_20bit=81;
      elf_reloc_loongarch_got64_high_12bit=82;
      elf_reloc_loongarch_tls_le_high_20bit=83;
      elf_reloc_loongarch_tls_le_low_12bit=84;
      elf_reloc_loongarch_tls_le64_low_20bit=85;
      elf_reloc_loongarch_tls_le64_high_12bit=86;
      elf_reloc_loongarch_tls_ie_pc_high_20bit=87;
      elf_reloc_loongarch_tls_ie_pc_low_12bit=88;
      elf_reloc_loongarch_tls_ie64_pc_low_20bit=89;
      elf_reloc_loongarch_tls_ie64_pc_high_12bit=90;
      elf_reloc_loongarch_tls_ie_high_20bit=91;
      elf_reloc_loongarch_tls_ie_low_12bit=92;
      elf_reloc_loongarch_tls_ie64_high_20bit=93;
      elf_reloc_loongarch_tls_ie64_low_12bit=94;
      elf_reloc_loongarch_tls_ld_pc_high_20bit=95;
      elf_reloc_loongarch_tls_ld_high_20bit=96;
      elf_reloc_loongarch_tls_global_dynamic_pc_high_20bit=97;
      elf_reloc_loongarch_tls_global_dynamic_high_20bit=98;
      elf_reloc_loongarch_32_pc_relative=99;
      elf_reloc_loongarch_relax=100;
      elf_reloc_loongarch_align=102;
      {ELF RISC-V Type}
      elf_riscv_b_type=1;
      elf_riscv_cb_type=2;
      elf_riscv_cj_type=3;
      elf_riscv_i_type=4;
      elf_riscv_s_type=5;
      elf_riscv_u_type=6;
      elf_riscv_j_type=7;
      elf_riscv_u_i_type=8;
      {ELF Archive File Type}
      elf_archive_magic:PChar='!<arch>'#10;
      elf_archive_file_magic:PChar='`'#10;
      {PE DOS Stub code}
      pe_dos_stub_code:array[1..64] of byte=($0E,$1F,$BA,$0E,$00,$B4,$09,$CD,$21,
      $B8,$01,$4C,$CD,$21,$54,$68,$69,$73,$20,$70,$72,$6F,$67,$72,$61,$6D,$20,$63,$61,$6E,$6E,$6F,
      $74,$20,$62,$65,$20,$72,$75,$6E,$20,$69,$6E,$20,$44,$4F,$53,$20,$6D,$6F,$64,$65,$2E,$0D,
      $0D,$0A,$24,$00,$00,$00,$00,$00,$00,$00);
      {PE Image Header File Machine}
      pe_image_file_machine_amd64:word=$8664;
      pe_image_file_machine_arm:word=$1C0;
      pe_image_file_machine_arm64:word=$AA64;
      pe_image_file_machine_arm_thumb:word=$1C2;
      pe_image_file_machine_i386:word=$14C;
      pe_image_file_machine_ia64:word=$200;
      pe_image_file_machine_loongarch32:word=$6232;
      pe_image_file_machine_loongarch64:word=$6264;
      pe_image_file_machine_riscv32:word=$5032;
      pe_image_file_machine_riscv64:word=$5064;
      pe_image_file_machine_riscv128:word=$5128;
      {PE Image Header File Characteristics}
      pe_image_file_characteristics_relocs_stripped:word=$0001;
      pe_image_file_characteristics_executable_image:word=$0002;
      pe_image_file_characteristics_line_number_stripped:word=$0004;
      pe_image_file_characteristics_symbol_stripped:word=$0008;
      pe_image_file_characteristics_large_address_aware:word=$0020;
      pe_image_file_characteristics_32bit_machine:word=$0100;
      pe_image_file_characteristics_debug_stripped:word=$0200;
      pe_image_file_characteristics_removeable_run_from_swap:word=$0400;
      pe_image_file_characteristics_net_run_from_swap:word=$0800;
      pe_image_file_characteristics_system:word=$1000;
      pe_image_file_characteristics_dll:word=$2000;
      pe_image_file_characteristics_system_only:word=$4000;
      {PE Image Header Subsystem}
      pe_image_subsystem_unknown:word=0;
      pe_image_subsystem_native:word=1;
      pe_image_subsystem_windows_gui:word=2;
      pe_image_subsystem_windows_cui:word=3;
      pe_image_subsystem_os2_cui:word=5;
      pe_image_subsystem_posix_cui:word=7;
      pe_image_subsystem_native_windows:word=8;
      pe_image_subsystem_windows_ce_gui:word=9;
      pe_image_subsystem_efi_application:word=10;
      pe_image_subsystem_efi_boot_service_driver:word=11;
      pe_image_subsystem_efi_runtime_service_driver:word=12;
      pe_image_subsystem_efi_rom:word=13;
      pe_image_subsystem_xbox:word=14;
      pe_image_subsystem_windows_boot_application:word=15;
      {PE Image Header DLL Characteristics}
      pe_image_dll_characteristics_high_entropy_virtual_address:word=$0020;
      pe_image_dll_characteristics_dynamic_base:word=$0040;
      pe_image_dll_characteristics_force_integrity:word=$0080;
      pe_image_dll_characteristics_nx_compat:word=$0100;
      pe_image_dll_characteristics_no_isolation:word=$0200;
      pe_image_dll_characteristics_no_structural_exception:word=$0400;
      pe_image_dll_characteristics_no_bind:word=$0800;
      pe_image_dll_characteristics_application_container:word=$1000;
      pe_image_dll_characteristics_wdm_driver:word=$2000;
      pe_image_dll_characteristics_guard_console:word=$4000;
      pe_image_dll_characteristics_terminal_service_aware:word=$8000;
      {PE Image Header Magic Number}
      pe_image_pe32:word=$10B;
      pe_image_pe32plus:word=$20B;
      pe_image_rom:word=$107;
      {PE Image Section Header Signals}
      pe_image_section_characteristics_type_no_pad:dword=$00000008;
      pe_image_section_characteristics_type_code:dword=$00000020;
      pe_image_section_characteristics_initialized_data:dword=$00000040;
      pe_image_section_characteristics_uninitialized_data:dword=$00000080;
      pe_image_section_characteristics_gprel:dword=$00008000;
      pe_image_section_characteristics_memory_discardable:dword=$02000000;
      pe_image_section_characteristics_memory_not_cached:dword=$04000000;
      pe_image_section_characteristics_memory_not_paged:dword=$08000000;
      pe_image_section_characteristics_memory_shared:dword=$10000000;
      pe_image_section_characteristics_memory_execute:dword=$20000000;
      pe_image_section_characteristics_memory_read:dword=$40000000;
      pe_image_section_characteristics_memory_write:dword=$80000000;
      {Coff Symbol Table Index}
      coff_image_symbol_undefined:smallint=0;
      coff_image_symbol_absolute:smallint=-1;
      coff_image_symbol_debug:smallint=-2;
      {Coff Symbol Type Low}
      coff_image_symbol_type_null:byte=0;
      coff_image_symbol_type_void:byte=1;
      coff_image_symbol_type_char:byte=2;
      coff_image_symbol_type_short:byte=3;
      coff_image_symbol_type_int:byte=4;
      coff_image_symbol_type_long:byte=5;
      coff_image_symbol_type_float:byte=6;
      coff_image_symbol_type_double:byte=7;
      coff_image_symbol_type_struct:byte=8;
      coff_image_symbol_type_union:byte=9;
      coff_image_symbol_type_enum:byte=10;
      coff_image_symbol_type_moe:byte=11;
      coff_image_symbol_type_byte:byte=12;
      coff_image_symbol_type_word:byte=13;
      coff_image_symbol_type_uint:byte=14;
      coff_image_symbol_type_dword:byte=15;
      {Coff Symbol Type High}
      coff_image_symbol_high_type_null:byte=0;
      coff_image_symbol_high_type_pointer:byte=1;
      coff_image_symbol_high_type_function:byte=2;
      coff_image_symbol_high_type_array:byte=3;
      {Coff Storage Class}
      coff_image_symbol_class_end_of_function:byte=$FF;
      coff_image_symbol_class_null:byte=0;
      coff_image_symbol_class_automatic:byte=1;
      coff_image_symbol_class_external:byte=2;
      coff_image_symbol_class_static:byte=3;
      coff_image_symbol_class_register:byte=4;
      coff_image_symbol_class_external_define_symbol:byte=5;
      coff_image_symbol_class_label:byte=6;
      coff_image_symbol_class_undefined_label:byte=7;
      coff_image_symbol_class_member_of_struct:byte=8;
      coff_image_symbol_class_argument:byte=9;
      coff_image_symbol_class_struct_tag:byte=10;
      coff_image_symbol_class_member_of_union:byte=11;
      coff_image_symbol_class_union_tag:byte=12;
      coff_image_symbol_class_type_definition:byte=13;
      coff_image_symbol_class_undefined_static:byte=14;
      coff_image_symbol_class_enum_tag:byte=15;
      coff_image_symbol_class_member_of_enum:byte=16;
      coff_image_symbol_class_register_param:byte=17;
      coff_image_symbol_class_bit_field:byte=18;
      coff_image_symbol_class_block:byte=100;
      coff_image_symbol_class_function:byte=101;
      coff_image_symbol_class_end_of_struct:byte=102;
      coff_image_symbol_class_section:byte=103;
      coff_image_symbol_class_weak_external:byte=104;
      coff_image_symbol_class_clr_token:byte=105;
      {Coff Image Base Relocation Type}
      coff_image_base_relocation_absolute:byte=0;
      coff_image_base_relocation_high:byte=1;
      coff_image_base_relocation_low:byte=2;
      coff_image_base_relocation_highlow:byte=3;
      coff_image_base_relocation_high_adjust:byte=4;
      coff_image_base_relocation_dir64:byte=10;
      {For DOS Code}
      pe_dos_code:array[1..$40] of byte=($0E,$1F,$BA,$0E,$00,$B4,$09,$CD,$21,
      $B8,$01,$4C,$CD,$21,$54,$68,$69,$73,$20,$70,$72,$6F,$67,$72,$61,$6D,$20,$63,$61,$6E,$6E,$6F,
      $74,$20,$62,$65,$20,$72,$75,$6E,$20,$69,$6E,$20,$44,$4F,$53,$20,$6D,$6F,$64,$65,$2E,$0D,
      $0D,$0A,$24,$00,$00,$00,$00,$00,$00,$00);

function elf_symbol_type_bind(Info:byte):byte;
function elf_symbol_type_type(Info:byte):byte;
function elf_symbol_type_info(SymbolBind,SymbolType:byte):byte;
function elf_symbol_type_visibility(other:byte):byte;
function elf32_reloc_symbol(val:elf32_word):elf32_word;
function elf32_reloc_type(val:elf32_word):elf32_word;
function elf32_reloc_info(InfoSymbol:elf32_word;InfoType:elf32_word):elf32_word;
function elf64_reloc_symbol(val:elf64_xword):elf64_xword;
function elf64_reloc_type(val:elf64_xword):elf64_xword;
function elf64_reloc_info(InfoSymbol:elf64_xword;InfoType:elf64_xword):elf64_xword;
function elf_move_symbol(info:dword):dword;
function elf_move_size(info:dword):dword;
function elf_move_info(info:dword):dword;
function elf_arm_eabi_version(flags:dword):dword;
function elf_check_signature(id:elf_file_id):boolean;
function elf_check_signature_for_file(content:PChar):boolean;
function elf_check_archive_signature(content:PChar):boolean;
function elf_get_class(id:elf_file_id):byte;
function elf_get_endian(id:elf_file_id):byte;
function elf_get_os_abi(id:elf_file_id):byte;
function elf_get_name(strtab:PChar;index:Dword):PChar;
function elf_hash(name:PChar):Dword;
function pe_calculate_checksum(data:Pointer;datasize:Dword):Dword;

implementation

function elf_symbol_type_bind(Info:byte):byte;
begin
 elf_symbol_type_bind:=Info shr 4;
end;
function elf_symbol_type_type(Info:byte):byte;
begin
 elf_symbol_type_type:=Info and $F;
end;
function elf_symbol_type_info(SymbolBind,SymbolType:byte):byte;
begin
 elf_symbol_type_info:=SymbolBind shl 4+SymbolType and $F;
end;
function elf_symbol_type_visibility(other:byte):byte;
begin
 elf_symbol_type_visibility:=other and $3;
end;
function elf32_reloc_symbol(val:elf32_word):elf32_word;
begin
 elf32_reloc_symbol:=val shr 8;
end;
function elf32_reloc_type(val:elf32_word):elf32_word;
begin
 elf32_reloc_type:=val and $FF;
end;
function elf32_reloc_info(InfoSymbol:elf32_word;InfoType:elf32_word):elf32_word;
begin
 elf32_reloc_info:=InfoSymbol shl 8+InfoType and $FF;
end;
function elf64_reloc_symbol(val:elf64_xword):elf64_xword;
begin
 elf64_reloc_symbol:=val shr 32;
end;
function elf64_reloc_type(val:elf64_xword):elf64_xword;
begin
 elf64_reloc_type:=val and $FFFFFFFF;
end;
function elf64_reloc_info(InfoSymbol:elf64_xword;InfoType:elf64_xword):elf64_xword;
begin
 elf64_reloc_info:=InfoSymbol shl 32+InfoType and $FFFFFFFF;
end;
function elf_move_symbol(info:dword):dword;
begin
 elf_move_symbol:=info shr 8;
end;
function elf_move_size(info:dword):dword;
begin
 elf_move_size:=Byte(info);
end;
function elf_move_info(info:dword):dword;
begin
 elf_move_info:=info;
end;
function elf_arm_eabi_version(flags:dword):dword;
begin
 elf_arm_eabi_version:=flags and elf_flags_arm_eabi_mask;
end;
function elf_check_signature(id:elf_file_id):boolean;
begin
 if(Char(id[1])=elf_magic[1]) and (Char(id[2])=elf_magic[2]) and (Char(id[3])=elf_magic[3])
 and(Char(id[4])=elf_magic[4]) then elf_check_signature:=true else elf_check_signature:=false;
end;
function elf_check_signature_for_file(content:PChar):boolean;
var i:dword;
begin
 if(content^=elf_magic[1]) and ((content+1)^=elf_magic[2]) and ((content+2)^=elf_magic[3])
 and((content+3)^=elf_magic[4]) then elf_check_signature_for_file:=true
 else elf_check_signature_for_file:=false;
end;
function elf_check_archive_signature(content:PChar):boolean;
var i:dword;
begin
 if(content=nil) then exit(false);
 for i:=1 to 8 do if((content+i-1)^<>(elf_archive_file_magic+i-1)^) then exit(false);
 elf_check_archive_signature:=true;
end;
function elf_get_class(id:elf_file_id):byte;
begin
 elf_get_class:=id[elf_class_position];
end;
function elf_get_endian(id:elf_file_id):byte;
begin
 elf_get_endian:=id[elf_data_position];
end;
function elf_get_os_abi(id:elf_file_id):byte;
begin
 elf_get_os_abi:=id[elf_os_abi_position];
end;
function elf_get_name(strtab:PChar;index:Dword):PChar;
begin
 elf_get_name:=strtab+index;
end;
function elf_hash(name:PChar):Dword;
var hash,x:dword;
    tempname:PChar;
begin
 hash:=0; x:=0; tempname:=name;
 while(tempname^<>#0)do
  begin
   hash:=hash shl 4+Byte(tempname^);
   x:=hash and $F0000000;
   if(x<>0) then
    begin
     hash:=hash xor (x shr 24);
     hash:=hash and (not x);
    end;
   inc(tempname);
  end;
 elf_hash:=hash and $7FFFFFFF;
end;
function pe_calculate_checksum(data:Pointer;datasize:Dword):Dword;
var sum,checksum:dword;
    i:dword;
begin
 if(datasize=0) or (data=nil) then exit(0)
 else
  begin
   sum:=0; checksum:=0; i:=1;
   while(i<=datasize)do
    begin
     sum:=Pword(data+i shl 1-2)^+checksum;
     checksum:=Word(sum)+sum shr 16;
     inc(i,2);
    end;
   pe_calculate_checksum:=checksum+datasize;
  end;
end;

end.


